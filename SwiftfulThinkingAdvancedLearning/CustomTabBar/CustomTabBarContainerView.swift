//
//  CustomTabBarContainerView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/14.
//

import SwiftUI

struct CustomTabBarContainerView<Content : View> : View {
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = [
        //        TabBarItem(iconName: "house", title: "Home", color: Color.red),
        //        TabBarItem(iconName: "heart", title: "Favorites", color: Color.blue),
        //        TabBarItem(iconName: "person", title: "Profile", color: Color.green),
    ]
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
        }
            .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
                // content (child view)에 .preference()로 value 보냄.
                print("tabs = \(value)")
                self.tabs = value
            }
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [
        .home, .favorites, .profile
    ]
    
    static var previews: some View {
        CustomTabBarContainerView(selection: .constant(tabs.first!)) {
            Color.red
        }
    }
}
