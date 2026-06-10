//
//  PrimaryButtonB.swift
//  Homey
//
//  Created by Muhammad Saleh Bagir Alatas on 04/06/26.
//

import SwiftUI

struct AuthButtonGoogle: View {
    var type: String?
    var color: Color = Color("AppPrimaryColor")
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(ImageResource.googleLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 17)
                Text("Continue with Google")
            }
            .font(.system(size: 18))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .background(.white)
        .clipShape(.capsule)
        .glassEffect()
    }
}

#Preview {
    AuthButtonGoogle() {}
}
