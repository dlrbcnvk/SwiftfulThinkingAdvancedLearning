//
//  VIewBuilderBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/13.
//

import SwiftUI

struct HeaderViewRegular: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Description")
                .font(.callout)
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct HeaderViewGeneric<Content: View>: View {
    
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            content
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct CustomHstack<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content
        }
    }
}

struct VIewBuilderBootcamp: View {
    var body: some View {
        VStack {
            HeaderViewRegular()
            
            HeaderViewGeneric(title: "Generic title") {
                VStack(alignment: .leading) {
                    Text("Hi")
                    Text("Hi")
                    HStack {
                        Text("Hi")
                        Text("Hi")
                    }
                }
            }
            
            CustomHstack {
                Text("Hello custom hstack~")
            }
            
            Spacer()
        }
    }
}

struct VIewBuilderBootcamp_Previews: PreviewProvider {
    static var previews: some View {
//        VIewBuilderBootcamp()
        LocalViewBuilder(type: .three)
    }
}

struct LocalViewBuilder: View {
    
    enum ViewType {
        case one, two, three
    }
    let type: ViewType
    
    var body: some View {
        VStack {
            headerSection
        }
    }
    
    @ViewBuilder
    private var headerSection: some View {
        switch type {
        case .one:
            viewOne
        case .two:
            viewTwo
        case .three:
            viewThree
        default:
            Text("What?")
        }
    }
    
    private var viewOne: some View {
        Text("One!")
    }
    private var viewTwo: some View {
        VStack {
            Text("Twooo~")
            Image(systemName: "heart.fill")
        }
    }
    private var viewThree: some View {
        Image(systemName: "person.fill")
    }
}
