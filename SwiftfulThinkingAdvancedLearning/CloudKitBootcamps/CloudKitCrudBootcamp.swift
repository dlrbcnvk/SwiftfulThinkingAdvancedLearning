//
//  CloudKitCrudBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/19.
//

import SwiftUI
import CloudKit

struct FruitModel: Hashable {
    let name: String
    let record: CKRecord
    let imageURL: URL?
}

class CloudKitCrudBootcampViewModel: ObservableObject {
    
    private let container = CKContainer(identifier: "iCloud.com.sunggyu.SwiftfulThinkingAdvancedLearning")
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = []
    
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
        
        // save image through FileManager and then use url at CKAsset
        guard
            let image = UIImage(named: "steve-jobs"),
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("steve-jobs.jpg"),
            let data = image.jpegData(compressionQuality: 1) else { return }
        
        do {
            try data.write(to: url)
            let asset = CKAsset(fileURL: url)
            newFruit["image"] = asset
            saveItem(record: newFruit)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func saveItem(record: CKRecord) {
        container.publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            print("Record: \(returnedRecord)")
            print("Error: \(returnedError)")
            DispatchQueue.main.async {
                self?.text = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.fetchItems()                   
                }
            }
        }
    }
    
    func fetchItems() {
        let predicate = NSPredicate(value: true)
//        let predicate = NSPredicate(format: "name = %@", argumentArray: [""])
        let query = CKQuery(recordType: "Fruits", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.resultsLimit = 2 // default 100
        
        var returnedItems: [FruitModel] = []
        
        if #available(iOS 15.0, *) {
            queryOperation.recordMatchedBlock = { returnedRecordID, returnedResult in
                switch returnedResult {
                case .success(let record):
                    guard let name = record["name"] as? String else { return }
                    let imageAsset = record["image"] as? CKAsset
                    let imageURL = imageAsset?.fileURL
                    print(record)
                    returnedItems.append(FruitModel(name: name, record: record, imageURL: imageURL))
//                    record.creationDate
                case .failure(let error):
                    print("\(#function) \(error.localizedDescription)")
                }
            }
        } else {
            // Fallback on earlier versions
            queryOperation.recordFetchedBlock = { returnedRecord in
                guard let name = returnedRecord["name"] as? String else { return }
                let imageAsset = returnedRecord["image"] as? CKAsset
                let imageURL = imageAsset?.fileURL
                print(returnedRecord)
                returnedItems.append(FruitModel(name: name, record: returnedRecord, imageURL: imageURL))
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
    
    func updateItem(fruit: FruitModel) {
        let record = fruit.record
        record["name"] = fruit.name + "😉"
        saveItem(record: record)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.fetchItems()
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        let record = fruit.record
        
        container.publicCloudDatabase.delete(withRecordID: record.recordID) { [weak self] returnedRecordID, returnedError in
            DispatchQueue.main.async {
                self?.fruits.remove(at: index)
            }
        }
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
                        HStack {
                            Text(fruit.name)
                            Spacer()
                            if
                                let url = fruit.imageURL,
                                let data = try? Data(contentsOf: url),
                                let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 55, height: 55)
                            }
                        }
                        .onTapGesture {
                            vm.updateItem(fruit: fruit)
                        }
                    }
                    .onDelete(perform: vm.deleteItem)
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
