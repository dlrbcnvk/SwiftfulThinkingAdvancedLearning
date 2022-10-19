//
//  AdvancedCombineBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/18.
//

import SwiftUI
import Combine

class AdvancedCombineDataService {
    
}

class AdvancedCombineBootcampViewModel: ObservableObject {
    
    @Published var data: [String] = []
}

struct AdvancedCombineBootcamp: View {
    
    @StateObject private var vm = AdvancedCombineBootcampViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AdvancedCombineBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedCombineBootcamp()
    }
}
