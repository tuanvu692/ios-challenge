//
//  HomeViewModel.swift
//  ios-challenge
//
//  Created by Vu Nguyen on 09/03/2022.
//

import Foundation

class HomeViewModel {
    private var activities = [Activity]()
    private var activityEntities = [ActivityEntity]()
    
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
    
    init(activityEntities: [ActivityEntity]) {
        self.activityEntities = activityEntities
    }
    
    func getActivities(completion: @escaping () -> Void) {
        ///`Create Object Of DispatchGroup`
        let dispatchGroup = DispatchGroup()
        ActivityType.allCases.forEach { type in
            for _ in 1...numberOfActivitiesPerType {
                dispatchGroup.enter()
                getData(EndPoints.activity(type: type.rawValue).url, Activity.self) { [weak self] data in
                    guard let self = self else { return }
                    self.activities.append(data)
                    dispatchGroup.leave()
                }
            }
        }
        /// `Notify Main thread`
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.cookActivityEntities()
            completion()
        }
    }
    
    private func cookActivityEntities() {
        ActivityType.allCases.forEach { type in
            var activityEntity = ActivityEntity()
            activityEntity.type = type
            activityEntity.activities = self.activities
                .filter{ $0.type == type }
                .sorted(by: { $0.accessibility < $1.accessibility })
            self.activityEntities.append(activityEntity)
        }
    }
    
    func numberOfSection() -> Int {
        return self.activityEntities.count
    }
    
    func numberOfRowInSection(section: Int) -> Int {
        return self.activityEntities[section].activities.count
    }
    
    func activityEntityForAt(section: Int) -> ActivityEntity {
        return self.activityEntities[section]
    }
    
    func activityForRowAt(indexPath: IndexPath) -> Activity {
        return self.activityEntities[indexPath.section].activities[indexPath.row]
    }
}

// Network layer
extension HomeViewModel {
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
