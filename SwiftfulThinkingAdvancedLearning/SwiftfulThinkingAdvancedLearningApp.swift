//
//  SwiftfulThinkingAdvancedLearningApp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/11.
//

import SwiftUI

@main
struct SwiftfulThinkingAdvancedLearningApp: App {
    
//    let currentUserIsSignedIn: Bool
//    
//    init() {
////        var userIsSignedIn: Bool = CommandLine.arguments.contains("-UITest_startSignedIn") ? true : false
//        let userIsSignedIn: Bool = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn") ? true : false
////        let value = ProcessInfo.processInfo.environment["-UITest_startSignedIn2"]
////        let userIsSignedIn: Bool = value == "true" ? true : false
//        self.currentUserIsSignedIn = userIsSignedIn
//    }
    
    var body: some Scene {
        WindowGroup {
//            UITestingBootcampView(currentUserIsSignedIn: currentUserIsSignedIn)
            
//            CloudKitUserBootcamp()
            CloudKitCrudBootcamp()
        }
    }
}
