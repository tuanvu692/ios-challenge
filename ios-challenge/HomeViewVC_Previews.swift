//
//  HomeViewVC_Previews.swift
//  ios-challenge
//
//  Created by Vu Nguyen on 10/03/2022.
//

import Foundation
import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewVC_Previews(storyboard: "Main", viewVC: "intialVC")
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
            .previewDisplayName("iPhone 11")
        
        HomeViewVC_Previews(storyboard: "Main", viewVC: "intialVC")
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("iPhone 8")
    }
}

struct ContentView: View {
  var body: some View {
        HomeViewVC_Previews(storyboard: "Main", viewVC: "intialVC")
  }
}

struct HomeViewVC_Previews: UIViewControllerRepresentable {
    let storyboard: String
    let viewVC: String
    
    func makeUIViewController(context: Context) -> HomeViewController {
        //Load the storyboard
        let loadedStoryboard = UIStoryboard(name: storyboard, bundle: nil)
        
        //Load the ViewController
        let vc = loadedStoryboard.instantiateViewController(withIdentifier: viewVC) as! HomeViewController
        vc.viewModel = HomeViewModel(activityEntities: [ActivityEntity(type: .recreational,
                                                                       activities: [Activity(activity: "This is Dummy Data",
                                                                                             key: "3943506",
                                                                                             type: .recreational,
                                                                                             accessibility: 2.0,
                                                                                             participants: 1.0,
                                                                                             price: 111)])])
        return vc
    }
    
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
        
    }
}
