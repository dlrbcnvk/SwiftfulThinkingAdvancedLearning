//
//  AnyTransitionBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/11.
//

import SwiftUI

struct RotateViewModifier: ViewModifier {
    
    let rotation: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotation))
            .offset(
                x: rotation != 0 ? UIScreen.main.bounds.width : 0,
                y: rotation != 0 ? UIScreen.main.bounds.height : 0)
    }
}

extension AnyTransition {
    
    static var rotating: AnyTransition {
        modifier(
            active: RotateViewModifier(rotation: 90),
            identity: RotateViewModifier(rotation: 0))
    }
    
    static func rotating(rotation: Double) -> AnyTransition {
        modifier(
            active: RotateViewModifier(rotation: rotation),
            identity: RotateViewModifier(rotation: 0))
    }
    
    static var rotateOn: AnyTransition {
        asymmetric(
            insertion: .rotating,
            removal: .move(edge: .leading))
    }
}

struct AnyTransitionBootcamp: View {
    
    @State private var showRectangle: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if showRectangle {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 250, height: 350)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .transition(.move(edge: .leading))
//                    .transition(AnyTransition.scale.animation(.easeInOut))
//                    .modifier(RotateViewModifier(rotation: 45))
//                    .transition(AnyTransition.rotating.animation(.easeInOut))
//                    .transition(.rotating(rotation: 270))
                    .transition(.rotateOn)
                
            }
            
            Spacer()
            
            Text("Click me!")
                .withDefaultButtonFormatting()
                .padding(.horizontal, 40)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showRectangle.toggle()
                    }
                }
        }
    }
}

struct AnyTransitionBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AnyTransitionBootcamp()
    }
}
