//
//  ProtocolsBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 조성규 on 2022/10/16.
//

import SwiftUI

protocol ColorThemeProtocol {
    var primary: Color { get }
    var secondary: Color { get }
    var tertiary: Color { get }
}

protocol ButtonTextProtocol {
    var buttonText: String { get }
}

protocol ButtonPressedProtocol {
    func buttonPressed()
}

protocol ButtonDataSourceProtocol: ButtonTextProtocol, ButtonPressedProtocol {
    
}

struct DefaultColorTheme: ColorThemeProtocol {
    let primary: Color = .blue
    let secondary: Color = .white
    let tertiary: Color = .gray
}

struct AlternativeColorTheme: ColorThemeProtocol {
    let primary: Color = .red
    let secondary: Color = .white
    let tertiary: Color = .green
}

struct AnotherColorTheme: ColorThemeProtocol {
    var primary: Color = .blue
    var secondary: Color = .red
    var tertiary: Color = .purple
}

class DefaultDataSource: ButtonDataSourceProtocol {
    var buttonText: String = "Protocols are awesome!"
    
    func buttonPressed() {
        
    }
}
class AlternativeDataSource: ButtonDataSourceProtocol {
    var buttonText: String = "Protocols are lame."
    
    func buttonPressed() {
        
    }
}


struct ProtocolsBootcamp: View {

    let colorTheme: ColorThemeProtocol
    let dataSource: ButtonDataSourceProtocol
    
    var body: some View {
        ZStack {
            colorTheme.tertiary
                .ignoresSafeArea()
            
            Text(dataSource.buttonText)
                .font(.headline)
                .foregroundColor(colorTheme.secondary)
                .padding()
                .background(colorTheme.primary)
                .cornerRadius(10)
                .onTapGesture {
                    dataSource.buttonPressed()
                }
        }
    }
}

struct ProtocolsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ProtocolsBootcamp(colorTheme: DefaultColorTheme(), dataSource: DefaultDataSource())
    }
}
