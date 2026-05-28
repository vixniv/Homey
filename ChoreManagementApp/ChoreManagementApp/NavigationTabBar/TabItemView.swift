//
//  TabItemView.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
// A custom individual tab item button

import SwiftUI

struct TabItemView: View {
    var value: String // Text shown on each tab item
    var systemImage: String // Symbol shown on each tab item
    var tabItem: TabItemEnum // TabItemEnum value of each view
    @Binding var selection: TabItemEnum // Binding variable of selected TabItem
    
    var body: some View {
        Button {
            selection = tabItem
        } label: {
            ZStack {
                if selection == tabItem {
                    Color(.orange) // color when selected
                }else {
                    Color(uiColor: .systemBackground) // color when not selected
                }
                
                VStack(spacing: 5){
                    Image(systemName: systemImage)
                        .font(.title2)
                    Text(value.lowercased().capitalized)
                }
                .foregroundStyle(.black)
                .fontWeight(.light)
            }
        }
    }
}

#Preview {
    TabItemView(value: "home", systemImage: "house", tabItem: .home, selection: .constant(.home))
}
