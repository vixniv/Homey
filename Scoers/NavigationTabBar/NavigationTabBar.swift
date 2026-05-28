//
//  NavigationTabBar.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct NavigationTabBar: View {
    @Binding var selectedTabItem: TabItemEnum // Binding variable of selected tab item
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                TabItemView(value: "home", systemImage: "house", tabItem: .home, selection: $selectedTabItem)
                
                TabItemView(value: "tasks", systemImage: "checkmark.square", tabItem: .tasks, selection: $selectedTabItem)
                
                
                TabItemView(value: "schedule", systemImage: "calendar", tabItem: .schedule, selection: $selectedTabItem)
                
                TabItemView(value: "profile", systemImage: "person", tabItem: .profile, selection: $selectedTabItem)
            }
            .frame(width: .infinity, height: 100)
            .fontWeight(.regular)
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    @Previewable @State var selectedTabItem = TabItemEnum.home
    
    VStack {

        Spacer()
        NavigationTabBar(selectedTabItem: $selectedTabItem)
    }
    .ignoresSafeArea() // This is important! so the tab bar fills to the bottom of the page
}
