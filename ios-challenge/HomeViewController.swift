//
//  ViewController.swift
//  ios-challenge
//
//  Created by Vu Nguyen on 09/03/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var activitiesTb: UITableView!
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getActivities()
    }
    
    private func setupUI() {
        activitiesTb.register(SectionHeaderView.self,
                              forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }
    
    private func getActivities() {
        viewModel.getActivities { [weak self] in
            guard let self = self else { return }
            self.activitiesTb.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let activity = viewModel.activityForRowAt(indexPath: indexPath)
        cell.textLabel?.text = "Accessibility: \(activity.accessibility)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)

        cell.detailTextLabel?.text = "Activity: \(activity.activity) \nParticipants: \(activity.participants)"
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        cell.detailTextLabel?.textColor = .systemGray

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowInSection(section: section)
    }
    
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
