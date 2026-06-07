//
//  HomeForm1.swift
//  Homey
//
//  Created by Muhammad Saleh Bagir Alatas on 05/06/26.
//

import SwiftUI

struct HomeNameForm: View {
    @State private var homeName: String = ""
    
    var body: some View {
        VStack {
            Text("What's your home called?")
            TextField("The Johnsons, Casa Familia", text:$homeName)
                .textFieldStyle()
            Text("This is how your home appears to all members.")
                .foregroundStyle(.secondary)
                .font(.subheadline)
            Spacer()
        }
        .navigationTitle("Start a new home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                PrimaryButton(title: "Next") {}
            }
        }
        .padding()
        .onSubmit {
            createHome(homeName)
        }
    }
}

#Preview {
    NavigationStack {
        HomeNameForm()
    }
}
