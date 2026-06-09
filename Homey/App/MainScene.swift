//
//  MainScene.swift
//  Homey
//

import SwiftUI

struct MainScene: View {
    @State private var isAddTaskPresented = false

    var body: some View {
        NavigationStack {
            HomeView()
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        isAddTaskPresented = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(Color.appPrimary)
                            .frame(width: 56, height: 56)
                    }
                    .glassEffect(.regular.interactive(), in: .circle)
                    .padding(.trailing, 16)
                    .padding(.bottom, 10)
                }
        }
        .sheet(isPresented: $isAddTaskPresented) {
            NavigationStack {
                TaskFormView(mode: .create)
            }
        }
    }
}

#Preview {
    MainScene()
}
