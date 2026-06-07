//
//  HeaderTitle.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct HeaderTitle: View {
    var name: String // name of the houshold member
    let date: Date = Date.now
    
    @State private var tasksModel = TasksModel()

    var body: some View {
        HStack {
            // Title Group
            VStack(alignment: .leading) {
                // Family Title
                Text("\(name.capitalized)'s Family House")
                    .font(.system(.headline, weight: .semibold))
                
                // Today's date
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
            }
            
            Spacer()
            
            // Notification button
            Button {
                //TODO: notification logic
                
            } label: {
                Image(systemName: "bell")
                    .font(.system(.title2, weight: .regular))
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    HeaderTitle(name: "ana")
        .padding() //added padding to preview to easily see
}

#Preview {
    ContentView()
}
