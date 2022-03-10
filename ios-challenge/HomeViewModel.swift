//
//  HomeViewModel.swift
//  ios-challenge
//
//  Created by Vu Nguyen on 09/03/2022.
//

import Foundation

final class HomeViewModel {
    var activities = [Activity]()
    
    static var mainURL = "http://www.boredapi.com/api/"
    let numberOfActivitiesPerType = 5
    
    enum EndPoints: RawRepresentable {
        init?(rawValue: String) { nil }
        
        case activity(type: String)
        
        var url: String {
            return HomeViewModel.mainURL + self.rawValue
        }
        
        var rawValue: String {
            switch self {
            case .activity(let type):
                return "activity?type=\(type)"
            }
        }
    }
    
    init() {
    }
    
    func getActivities(completion: @escaping () -> Void) {
        ///`Create Object Of DispatchGroup`
        let dispatchGroup = DispatchGroup()
        
        ActivityType.allCases.forEach { type in
            for _ in 1...numberOfActivitiesPerType {
                dispatchGroup.enter()
                getData(EndPoints.activity(type: type.rawValue).url, Activity.self) { data in
                    self.activities.append(data)
                    dispatchGroup.leave()
                }
            }
        }
        /// `Notify Main thread`
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
        
    private func getData<DataKind:Codable>(_ url: String,_
                                           dataKind: DataKind.Type, _
                                           completion: @escaping (_ data: DataKind) -> Void ) {
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil && data != nil {
                let convertedData = try! JSONDecoder().decode(dataKind, from: data!)
                completion(convertedData)
            }
        }.resume()
    }
}
