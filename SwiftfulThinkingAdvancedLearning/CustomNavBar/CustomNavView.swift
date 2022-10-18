//
//  CustomNavView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/16.
//

import SwiftUI

struct CustomNavView<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            CustomNavBarContainerView {
                content
            }
//            .toolbar(.hidden)
            .navigationBarHidden(true)
        }
//        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CustomNavView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavView {
            Color.pink.opacity(0.25)
                .ignoresSafeArea()
        }
    }
}

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        print("\(#function) \(self.description)")
        interactivePopGestureRecognizer?.delegate = nil
    }
}
