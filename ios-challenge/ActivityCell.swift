//
//  ActivityCell.swift
//  ios-challenge
//
//  Created by Vu Nguyen on 11/03/2022.
//

import Foundation
import UIKit

final class ActivityCell: UITableViewCell {
    static let reuseIdenfifier = "ActivityCell"
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var detailTitleLb: UILabel!
    @IBOutlet weak var actionLb: UILabel!
    
    var activity: Activity?
    
    var tapOnLink: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadData(activity: Activity) {
        self.activity = activity
        titleLb.text = "Accessibility: \(activity.accessibility)"
        titleLb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        detailTitleLb.text = "Activity: \(activity.activity) \nParticipants: \(activity.participants) \nLink: \(activity.link)"
        detailTitleLb.numberOfLines = 0
        detailTitleLb.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        detailTitleLb.textColor = .systemGray
        addGesture(label: actionLb)
    }
    
    func addGesture(label: UILabel) {
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        tapGesture.numberOfTapsRequired = 1
        
        label.addGestureRecognizer(tapGesture)
        label.addGestureRecognizer(longGesture)
    }
    
    @objc func tap() {
    }

    @objc func longPress(gesture:UIGestureRecognizer) {
        if gesture.state == .ended { return }
        if UIDevice().type == .iPhone8 || UIDevice().type == .iPhone11 {
            guard let activity = self.activity, !activity.link.isEmpty else { return }
            if tapOnLink != nil {
                tapOnLink!(activity.link)
            }
        }
    }
}
