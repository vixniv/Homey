//
//  RootView.swift
//  Homey
//

import SwiftUI

struct RootView: View {
    @State private var appModel = AppModel()

    var body: some View {
        TabView(selection: $appModel.selectedTab) {
            Tab("Home", systemImage: "house.fill", value: AppTab.home) {
                HomeView()
            }
            Tab("Statistics", systemImage: "chart.bar.fill", value: AppTab.statistics) {
                StatisticsView()
            }
            Tab("Profile", systemImage: "person.fill", value: AppTab.profile) {
                ProfileView()
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                appModel.isAddTaskPresented = true
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
        .sheet(isPresented: $appModel.isAddTaskPresented) {
            NavigationStack {
                AddTaskView()
            }
        }
    }
}

#Preview {
    RootView()
}
