//
//  CloudKitPushNotificationBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/20.
//

import SwiftUI
import CloudKit

class CloudKitPushNotificationBootcampViewModel: ObservableObject {
    
    private let container = CKContainer(identifier: "iCloud.com.sunggyu.SwiftfulThinkingAdvancedLearning")

    func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("\(#function) \(error.localizedDescription)")
            } else if success {
                print("Notification permissions success!")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permissions failure")
            }
        }
    }
    
    func subscribeToNotifications() {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "Fruits", predicate: predicate, subscriptionID: "fruit_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "There's a new fruit!"
        notification.alertBody = "Open the app to check your fruits."
        notification.soundName = "default"
        subscription.notificationInfo = notification
        
        container.publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print("\(#function) \(error.localizedDescription)")
            } else {
                print("Successfully subscribed to notifications!")
            }
        }
    }
    
    func unsubscribeToNotifications() {
        
        // 모든 subscriptions 조회하기
//        container.publicCloudDatabase.fetchAllSubscriptions { <#[CKSubscription]?#>, <#Error?#> in
//            <#code#>
//        }
        
        container.publicCloudDatabase.delete(withSubscriptionID: "fruit_added_to_database") { returnedID, returnedError in
            if let error = returnedError {
                print("\(#function) \(error.localizedDescription)")
            } else {
                print("Successfully unsubscribed!")
            }
        }
    }
    
}


struct CloudKitPushNotificationBootcamp: View {
    
    @StateObject private var vm = CloudKitPushNotificationBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            
            Button("Request notification permissions") {
                vm.requestNotificationPermissions()
            }
            
            Button("Subscribe to notifications") {
                vm.subscribeToNotifications()
            }
            
            Button("Unsubscribe to notifications") {
                vm.unsubscribeToNotifications()
            }
        }
    }
}

struct CloudKitPushNotificationBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitPushNotificationBootcamp()
    }
}
