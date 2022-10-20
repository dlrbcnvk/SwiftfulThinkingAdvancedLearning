//
//  AdvancedCombineBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/18.
//

import SwiftUI
import Combine

enum HuingError: Error {
    case huing
}

class AdvancedCombineDataService {
    
    @Published var basicPublisher: String = ""
//    let currentValuePublisher = CurrentValueSubject<Int, Error>("first publish")
    let passThroughPublisher = PassthroughSubject<Int, Error>()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        let items: [Int] = [1,2,3,4,5,6,7,8,9,10]
        
        for x in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x) / 2) {
                self.passThroughPublisher.send(items[x])
//                self.currentValuePublisher.send(items[x])
//                self.basicPublisher = items[x]

                if x == items.indices.last {
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
        }
        
        // for debounce practice
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//            self.passThroughPublisher.send(1)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.passThroughPublisher.send(2)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.passThroughPublisher.send(3)
//        }
    }
}

class AdvancedCombineBootcampViewModel: ObservableObject {
    
    @Published var data: [String] = []
    @Published var error: String = ""
    let dataService = AdvancedCombineDataService()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.passThroughPublisher
            // Sequence Operations
            /*
    //            .first()
    //            .first(where: { int in
    //                int < 4
    //            })
    //            .first(where: { $0 > 4 })
    //            .tryFirst(where: { int in
    //                if int == 3 {
    //                    throw URLError(.badServerResponse)
    //                }
    //                return int > 1
    //            })
    //            .last()
    //            .last(where: { $0 < 4 })
    //            .tryLast(where: { int in
    //                if int == 3 {
    //                    throw HingError.hing
    //                }
    //                return int > 1
    //            })
    //            .dropFirst()
    //            .dropFirst(2)
    //            .drop(while: { $0 > 5 })
    //            .tryDrop(while: { int in
    //                if int == 5 {
    //                    throw HingError.hing
    //                }
    //                return int < 4
    //            })
    //            .prefix(4)
    //            .prefix(while: { $0 > 5 })
    //            .tryPrefix(while: <#T##(Int) throws -> Bool#>)
    //            .output(at: 2)
    //            .output(in: 2..<5)
                */
            
            // Mathematic Operations
            /*
    //            .max()
    //            .max(by: { int1, int2 in
    //                return int1 < int2
    //            })
    //            .tryMax(by: <#T##(Int, Int) throws -> Bool#>)
    //            .min()
    //            .min(by: <#T##(Int, Int) -> Bool#>)
    //            .tryMin(by: <#T##(Int, Int) throws -> Bool#>)
            */
        
            // Filter / Reducing Operations
            /*
//            .map({ String($0) })
//            .tryMap({ int in
//                if int == 5 {
//                    throw HuingError.huing
//                }
//                return String(int)
//            })
//            .compactMap({ int in
//                if int == 5 {
//                    return nil
//                }
//                return String(int)
//            })
//            .tryCompactMap(<#T##transform: (Int) throws -> T?##(Int) throws -> T?#>)
//            .filter({ $0 > 3 && $0 < 7 })
//            .tryFilter(<#T##isIncluded: (Int) throws -> Bool##(Int) throws -> Bool#>)
//            .removeDuplicates()
//            .removeDuplicates(by: { int1, int2 in
//                return int1 < int2
//            })
//            .replaceNil(with: 5000)
//            .replaceEmpty(with: [])
//            .replaceError(with: 777)
//            .scan(0, { existingValue, newValue in
//                return existingValue + newValue
//            })
//            .scan(0, { $0 + $1 })
//            .scan(0, +)
//            .tryScan(<#T##initialResult: T##T#>, <#T##nextPartialResult: (T, Int) throws -> T##(T, Int) throws -> T#>)
//            .reduce(0, { existingValue, newValue in
//                return existingValue + newValue
//            })
//            .collect()
//            .collect(3)
//            .allSatisfy({ (0...100).contains($0) })
//            .tryAllSatisfy(<#T##predicate: (Int) throws -> Bool##(Int) throws -> Bool#>)
             */
        
            // Timing Operations
            /*
//            .debounce(for: 0.75, scheduler: DispatchQueue.main)
//            .delay(for: 2, scheduler: DispatchQueue.main)
        
//            .measureInterval(using: DispatchQueue.main)
//            .map({ stride in
//                return "\(stride.timeInterval)"
//            })
        
//            .throttle(for: 10, scheduler: DispatchQueue.main, latest: true)
//            .retry(3)
//            .timeout(0.5, scheduler: DispatchQueue.main)
            */
        
            // Multiple Publishers/Subscribers
            
        
        
            .map({ String($0) })
            
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print(completion)
                case .failure(let error):
                    self?.error = "ERROR: \(error.localizedDescription)"
               }
            } receiveValue: { [weak self] returnedValue in
                self?.data.append(returnedValue)
            }
            .store(in: &cancellables)
            
    }
}

struct AdvancedCombineBootcamp: View {
    
    @StateObject private var vm = AdvancedCombineBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.data, id: \.self) { item in
                    Text(item)
                        .font(.title)
                        .fontWeight(.medium)
                }
                
                if !vm.error.isEmpty {
                    Text(vm.error)
                }
            }
        }
    }
}

struct AdvancedCombineBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedCombineBootcamp()
    }
}
