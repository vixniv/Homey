//
//  PrimaryButtonB.swift
//  Homey
//
//  Created by Muhammad Saleh Bagir Alatas on 04/06/26.
//

import SwiftUI

struct AuthButtonApple: View {
    var type: String?
    var color: Color = Color("AppPrimaryColor")
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "apple.logo")
                Text("Continue with apple")
            }
            .font(.system(size: 18))
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .background(.white)
        .clipShape(.capsule)
        .glassEffect()
    }
}

#Preview {
    AuthButtonApple() {}
}
