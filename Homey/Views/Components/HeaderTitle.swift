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
                Text("\(name.capitalized)'s Family")
                    .font(.system(.headline, weight: .semibold))
                
                // Today's date
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
            }
            
            Spacer()
            
            //Add task
            NavigationLink() {
                AddTaskView(tasksModel: tasksModel)
            }label : {
                Image(systemName: "plus")
                    .font(.system(.title2, weight: .regular))
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color.appPrimary)
                    .clipShape(Circle())
            }
            
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
