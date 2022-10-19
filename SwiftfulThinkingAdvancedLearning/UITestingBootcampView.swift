//
//  UITestingBootcampView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/18.
//

import SwiftUI

class UITestingBootcampViewModel: ObservableObject {
    
    let placeholderText: String = "Add here"
    @Published var textFieldText: String = ""
    @Published var currentUserIsSignedIn: Bool
    
    init(currentUserIsSignedIn: Bool) {
        self.currentUserIsSignedIn = currentUserIsSignedIn
    }
    
    func signUpButtonPressed() {
        guard !textFieldText.isEmpty else { return }
        currentUserIsSignedIn = true
    }
}

struct UITestingBootcampView: View {
    
    @StateObject private var vm: UITestingBootcampViewModel
    
    init(currentUserIsSignedIn: Bool) {
        _vm = StateObject(wrappedValue: UITestingBootcampViewModel(currentUserIsSignedIn: currentUserIsSignedIn))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ZStack {
                if vm.currentUserIsSignedIn {
                    SignedInHomeView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .trailing))
                        .foregroundColor(.white)
                }
                if !vm.currentUserIsSignedIn {
                    signUpLayer
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
            }
            
        }
    }
}

struct UITestingBootcampView_Previews: PreviewProvider {
    static var previews: some View {
        UITestingBootcampView(currentUserIsSignedIn: false)
    }
}

extension UITestingBootcampView {
    
    private var signUpLayer: some View {
        VStack {
            TextField(vm.placeholderText, text: $vm.textFieldText)
                .font(.headline)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .accessibilityIdentifier("SignUpTextField")
            
            Button {
                withAnimation(.spring()) {
                    vm.signUpButtonPressed()
                }
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .accessibilityIdentifier("SignUpButton")
        }
        .padding()
    }
}

struct SignedInHomeView: View {
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Show welcome alert!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("ShowAlertButton")
                .alert(isPresented: $showAlert) {
                    return Alert(title: Text("Welcome to the alert!"))
                }

                NavigationLink {
                    Text("Destination")
                        .foregroundColor(.black)
                } label: {
                    Text("Navigate")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("NavigationLinkToDestination")
            }
            .padding()
            .navigationTitle("Welcome")
        }
    }
}
