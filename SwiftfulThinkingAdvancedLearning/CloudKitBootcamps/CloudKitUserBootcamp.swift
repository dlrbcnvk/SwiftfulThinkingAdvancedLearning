//
//  CloudKitUserBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/18.
//

import SwiftUI
import CloudKit


class CloudKitUserBootcampViewModel: ObservableObject {
    
    
    private let container = CKContainer(identifier: "iCloud.com.sunggyu.SwiftfulThinkingAdvancedLearning")
    private let container2 = CKContainer(identifier: "iCloud.sunggyu.SwiftfulThinkingAdvancedLearning")
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var permissionStatus: Bool = false
    @Published var username: String = ""
    
    init() {
        getiCloudStatus()
//        checkPermissionState()
        requestPermission()
        fetchiCloudUserRecordID()
    }
    
    private func getiCloudStatus() {
        container.accountStatus { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                switch returnedStatus {
                case .available:
                    self?.isSignedInToiCloud = true
                case .noAccount:
                    self?.error = CloudKitError.iCloudAccountNotFound.rawValue
                case .couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccountNotDetermined.rawValue
                case .restricted:
                    self?.error = CloudKitError.iCloudAccountRestricted.rawValue
                default:
                    self?.error = CloudKitError.iCloudAccountUnknown.rawValue
                }
            }
        }
    }
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
    
    func checkPermissionState() {
        container.status(forApplicationPermission: .userDiscoverability) { status, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("\(#function) \(error.localizedDescription)")
                }
                print("\(status)")
            }
        }
    }
    
    func requestPermission() {
        container.requestApplicationPermission(.userDiscoverability) { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                if let error = returnedError {
                    print("\(#function) \(error.localizedDescription)")
                }
                if returnedStatus == .granted {
                    self?.permissionStatus = true
                }
                print("\(returnedStatus)")
            }
        }
    }
    
    func fetchiCloudUserRecordID() {
        container.fetchUserRecordID { [weak self] returnedID, returnedError in
            if let error = returnedError {
                print("\(#function) \(error.localizedDescription)")
            }
            if let id = returnedID {
                self?.discoveriCloudUser(id: id)
            }
            
        }
    }
    
    func discoveriCloudUser(id: CKRecord.ID) {
        container.discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
            DispatchQueue.main.async {
                if let error = returnedError {
                    print("\(#function) \(error.localizedDescription)")
                }
                if let name = returnedIdentity?.nameComponents?.givenName {
                    self?.username = name
                }
                
//                guard let lookupInfo = returnedIdentity?.lookupInfo else { return }
//                print(lookupInfo)
            }
        }
    }
}

struct CloudKitUserBootcamp: View {
    
    @StateObject private var vm = CloudKitUserBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("IS SIGNED IN: \(vm.isSignedInToiCloud.description)")
            Text(vm.error)
            Text("Permission: \(vm.permissionStatus.description)")
            Text("NAME: \(vm.username)")
        }
        .padding()
    }
}

struct CloudKitUserBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitUserBootcamp()
    }
}
