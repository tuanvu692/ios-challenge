//
//  ActivityModel.swift
//  ios-challenge
//
//  Created by Vu Nguyen on 09/03/2022.
//

import Foundation

struct Activity: Codable {
    let activity, key, link: String
    let type: ActivityType
    let accessibility, participants, price: Double
}

struct ActivityEntity {
    var type: ActivityType = .education
    var activities: [Activity] = []
}

enum ActivityType: String, CaseIterable, Codable {
    case education
    case recreational
    case social
    case diy
    case charity
    case cooking
    case relaxation
    case music
    case busywork
}
