//
//  SectionHeaderView.swift
//  ios-challenge
//
//  Created by Vu Nguyen on 10/03/2022.
//

import UIKit

final class SectionHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = String(describing: self)

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
