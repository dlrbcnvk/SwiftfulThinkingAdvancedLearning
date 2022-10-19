//
//  CloudKitCrudBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/19.
//

import SwiftUI
import CloudKit

class CloudKitCrudBootcampViewModel: ObservableObject {
    
    private let container = CKContainer(identifier: "iCloud.com.sunggyu.SwiftfulThinkingAdvancedLearning")
    @Published var text: String = ""
    @Published var fruits: [String] = []
    
    init() {
        fetchItems()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addItem(name: text)
    }
    
    private func addItem(name: String) {
        let newFruit = CKRecord(recordType: "Fruits")
        newFruit["name"] = name
        saveItem(record: newFruit)
    }
    
    private func saveItem(record: CKRecord) {
        container.publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            print("Record: \(returnedRecord)")
            print("Error: \(returnedError)")
            DispatchQueue.main.async {
                self?.text = ""
            }
        }
    }
    
    func fetchItems() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Fruits", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedItems: [String] = []
        
        if #available(iOS 15.0, *) {
            queryOperation.recordMatchedBlock = { returnedRecordID, returnedResult in
                switch returnedResult {
                case .success(let record):
                    guard let name = record["name"] as? String else { return }
                    returnedItems.append(name)
//                    record.creationDate
                case .failure(let error):
                    print("\(#function) \(error.localizedDescription)")
                }
            }
        } else {
            // Fallback on earlier versions
            queryOperation.recordFetchedBlock = { returnedRecord in
                guard let name = returnedRecord["name"] as? String else { return }
                returnedItems.append(name)
            }
        }
        
        if #available(iOS 15.0, *) {
            queryOperation.queryResultBlock = { [weak self] returnedResult in
                print("Returned result: \(returnedResult)")
                DispatchQueue.main.async {
                    self?.fruits = returnedItems
                }
            }
        } else {
            // Fallback on earlier versions
            queryOperation.queryCompletionBlock = { [weak self] (returnedCursor, returnedError) in
                print("returned queryCompletionBlock")
                DispatchQueue.main.async {
                    self?.fruits = returnedItems
                }
            }
        }
        
        addOperation(operation: queryOperation)
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        
        container.publicCloudDatabase.add(operation)
    }
}

struct CloudKitCrudBootcamp: View {
    
    @StateObject private var vm = CloudKitCrudBootcampViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                header
                textField
                addButton

                List {
                    ForEach(vm.fruits, id: \.self) { fruit in
                        Text(fruit)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .padding()
        }
    }
}

struct CloudKitCrudBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitCrudBootcamp()
    }
}

extension CloudKitCrudBootcamp {
    
    private var header: some View {
        Text("CloudKit CRUD ☁️☁️☁️☁️☁️")
            .font(.headline)
            .underline()
    }
    
    private var textField: some View {
        TextField("Add something here...", text: $vm.text)
            .frame(height: 55)
            .padding(.leading)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .textInputAutocapitalization(.never)
    }
    
    private var addButton: some View {
        Button {
            vm.addButtonPressed()
        } label: {
            Text("Add")
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.pink.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(.headline)
        }
    }
}
