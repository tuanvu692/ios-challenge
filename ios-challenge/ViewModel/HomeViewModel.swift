//
//  HomeViewModel.swift
//  ios-challenge
//
//  Created by Vu Nguyen on 09/03/2022.
//

import Foundation
import UIKit
import LinkPresentation

class HomeViewModel {
    private var activities = [Activity]()
    private var activityEntities = [ActivityEntity]()
    let numberOfActivitiesPerType = 5

    init() {}
    
    func getActivities(completion: @escaping () -> Void) {
        ///`Create Object Of DispatchGroup`
        let dispatchGroup = DispatchGroup()
        ActivityType.allCases.forEach { type in
            for _ in 1...numberOfActivitiesPerType {
                dispatchGroup.enter()
                getData(EndPoints.activity(type: type.rawValue).url, Activity.self) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case let .failure(error):
                        print("Error: \(error.localizedDescription) - \(type)")
                    case let .success(data):
                        self.activities.append(data)
                    }
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

// Network Layer
extension HomeViewModel {
    static var mainURL = "http://www.boredapi.com/api/"
    enum ApiError: Error {
        case badRequest
    }

    enum EndPoints: RawRepresentable {
        init?(rawValue: String) { nil }
        
        case activity(type: String)
        
        var url: String {
            return mainURL + self.rawValue
        }
        
        var rawValue: String {
            switch self {
            case .activity(let type):
                return "activity?type=\(type)"
            }
        }
    }

    private func getData<DataKind:Codable>(_ url: String,_
                                           dataKind: DataKind.Type, _
                                           completion: @escaping (Result<DataKind, Error>) -> Void ) {
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ApiError.badRequest))
                return
            }
            do {
                let convertedData = try JSONDecoder().decode(dataKind, from: data)
                completion(.success(convertedData))
            } catch let parseError {
                completion(.failure(parseError))
            }
        }.resume()
    }
    
    func fetchMetadata(for link: String, completion: @escaping (Result<LPLinkMetadata, Error>) -> Void) {
        guard let url = URL(string: link) else { return }
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let metadata = metadata {
                completion(.success(metadata))
            }
        }
    }
}

