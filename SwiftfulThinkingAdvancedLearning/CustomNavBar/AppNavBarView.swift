//
//  AppNavBarView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/16.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        CustomNavView {
            ZStack {
                Color.orange.ignoresSafeArea()
                
                CustomNavLink {
                    Text("Destination")
                        .customNavigationTitle("Second Screen")
                        .customNavigationSubtitle("Subtitle should be showing!!")
                } label: {
                    Text("Navigate")
                }
            }
//            .customNavigationTitle("Custom Title")
//            .customNavigationBarBackButtonHidden(true)
            .customNavBarItems(title: "New Title", subtitle: nil, backButtonHidden: true)
        }
    }
}

struct AppNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppNavBarView()
    }
}

extension AppNavBarView {
    
    private var defaultNavView: some View {
        NavigationView {
            ZStack {
                Color.green
                    .ignoresSafeArea()
                
                NavigationLink {
                    Text("Destination")
                        .navigationTitle("Title 2")
                        .navigationBarBackButtonHidden(false)
                } label: {
                    Text("Navigate")
                }
                
            }
            .navigationTitle("Nav Title Here")
        }
    }
}
