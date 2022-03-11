//
//  ViewController.swift
//  ios-challenge
//
//  Created by Vu Nguyen on 09/03/2022.
//

import UIKit
import SwiftUI
import LinkPresentation

class HomeViewController: UIViewController {
    @IBOutlet weak var activitiesTb: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var viewModel = HomeViewModel()
    private var currentLinkView = LPLinkView()
    private var linkView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading(show: true)
        setupUI()
        getActivities()
    }
    
    private func setupUI() {
        activitiesTb.register(SectionHeaderView.self,
                              forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
        activitiesTb.register(UINib(nibName: ActivityCell.reuseIdenfifier, bundle: nil),
                              forCellReuseIdentifier: ActivityCell.reuseIdenfifier)
    }
    
    private func getActivities() {
        viewModel.getActivities { [weak self] in
            guard let self = self else { return }
            self.showLoading(show: false)
            self.activitiesTb.reloadData()
        }
    }
    
    func showLoading(show: Bool) {
        if show {
            self.indicatorView.startAnimating()
        } else {
            self.indicatorView.stopAnimating()
        }
    }
    
    private func fetchMetadataFor(urlString: String) {
        viewModel.fetchMetadata(for: urlString) { [weak self] result in
            guard let self = self else { return }
            self.handleLinkFetchResult(result)
        }
    }
    
    private func handleLinkFetchResult(_ result: Result<LPLinkMetadata, Error>) {
        DispatchQueue.main.async {
            self.showLoading(show: false)
            switch result {
            case .success(let metadata):
                self.closeLinkView()
                self.setupLinkView(metadata: metadata)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupLinkView(metadata: LPLinkMetadata) {
        self.view.addSubview(self.linkView)
        self.linkView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        self.linkView.center = self.view.center

        let closeBtn = UIButton()
        closeBtn.setTitleColor(.black, for: .normal)
        closeBtn.setTitle("Close", for: .normal)
        self.linkView.addSubview(closeBtn)
        closeBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        closeBtn.addTarget(self, action: #selector(self.closeLinkView), for: .touchUpInside)
        
        self.currentLinkView = LPLinkView(metadata: metadata)
        self.linkView.addSubview(self.currentLinkView)
        self.currentLinkView.frame = CGRect(x: 0, y: 25, width: 300, height: 375)
    }
    
    @objc func closeLinkView() {
        self.currentLinkView.removeFromSuperview()
        self.linkView.removeFromSuperview()
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityCell.reuseIdenfifier,
                                                       for: indexPath) as? ActivityCell else {
            return UITableViewCell()
        }
        let activity = viewModel.activityForRowAt(indexPath: indexPath)
        cell.loadData(activity: activity)
        cell.tapOnLink = { [weak self] link in
            guard let self = self else { return }
            self.showLoading(show: true)
            self.fetchMetadataFor(urlString: link)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowInSection(section: section)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier)
                as? SectionHeaderView else { return nil }
        let activityEntity = viewModel.activityEntityForAt(section: section)
        view.textLabel?.text = activityEntity.type.rawValue.uppercased()
        view.textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        return view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
