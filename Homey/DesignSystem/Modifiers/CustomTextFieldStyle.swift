//
//  CustomTextFieldStyle.swift
//  Homey
//
//  Created by Muhammad Saleh Bagir Alatas on 04/06/26.
//

import SwiftUI

// custom text field style
struct TextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .overlay {
                Capsule()
                    .stroke(.gray)
                    .opacity(0.5)
            }
    }
}

extension View {
    func textFieldStyle() -> some View {
        modifier(TextFieldStyle())
    }
}
//
//#Preview {
//    @Previewable @State private var textBinding: String
//    
//    TextField("Enter your name", text: $textBinding)
//        .textFieldStyle()
//}
