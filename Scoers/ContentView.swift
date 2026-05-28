//
//  ContentView.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTabItem: TabItemEnum = .home
    var body: some View {
        VStack {
            // page switch
            VStack {
                switch(selectedTabItem) {
                case .progress:
                    ProgressView()
                case .schedule:
                    ScheduleView()
                case .profile:
                    ProfileView()
                default:
                    HomeView()
                }
            }
            .frame(maxHeight: .infinity)
            .padding()

            Spacer()
            
            NavigationTabBar(selectedTabItem: $selectedTabItem)
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
