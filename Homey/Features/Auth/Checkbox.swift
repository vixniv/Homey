//
//  Checkbox.swift
//  Homey
//
//  Created by Muhammad Saleh Bagir Alatas on 08/06/26.
//

import SwiftUI

struct Checkbox: View {
    @Binding var isOn: Bool
    var diameter: Double = 24
    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Circle()
                .stroke(.gray)
                .frame(width: diameter, height: diameter)
                .overlay {
                    if isOn {
                        Circle()
                            .foregroundStyle(.blue)
                            .scaleEffect(0.7)
                    }
                }
        }
    }
}

#Preview {
    @Previewable @State var isEnabled = false
    Checkbox(isOn: $isEnabled)
}
