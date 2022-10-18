//
//  PreferenceKeyBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/13.
//

import SwiftUI

struct PreferenceKeyBootcamp: View {
    
    @State var text: String = "Hello world"
    
    var body: some View {
        NavigationView {
            VStack {
                SecondScreen(text: text)
                    .navigationTitle("Navigation Title")
            }
            .onPreferenceChange(CustomTitlePrefrenceKey.self) { value in
                self.text = value
            }
        }
    }
}

extension View {
    
    func customTitle(_ text: String) -> some View {
        self
            .preference(key: CustomTitlePrefrenceKey.self, value: text)
    }
}

struct PreferenceKeyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceKeyBootcamp()
    }
}

struct SecondScreen: View {
    
    let text: String
    @State private var newValue: String = ""
    
    var body: some View {
        Text(text)
            .onAppear(perform: getDataFromDatabase)
            .customTitle(newValue)
//            .preference(key: CustomTitlePrefrenceKey.self, value: "Hiiii")
    }
    
    func getDataFromDatabase() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.newValue = "New value from database"
        }
    }
}

struct CustomTitlePrefrenceKey: PreferenceKey {
    
    static var defaultValue: String = "default value"
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}
