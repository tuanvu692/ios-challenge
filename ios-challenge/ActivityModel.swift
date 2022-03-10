//
//  ActivityModel.swift
//  ios-challenge
//
//  Created by Vu Nguyen on 09/03/2022.
//

import Foundation

struct Activity: Codable {
    let activity, key: String
    let type: ActivityType
    let accessibility, participants, price: Double
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

/*
 {
     "activity": "Learn how to play a new sport",
     "accessibility": 0.2,
     "type": "recreational",
     "participants": 1,
     "price": 0.1,
     "key": "5808228"
 }
 */
