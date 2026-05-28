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
    var body: some View {
        HStack {
            // Title Group
            VStack(alignment: .leading) {
                // Family Title
                Text("\(name.capitalized)'s Family")
                    .font(.system(.title, weight: .semibold))
                
                // Today's date
                Text(date.formatted(date: .abbreviated, time: .omitted))
            }
            
            Spacer()
            
            // Notification button
            Button {
                //TODO: notification logic
                
            } label: {
                Image(systemName: "bell")
                    .font(.title)
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    HeaderTitle(name: "ana")
        .padding() //added padding to preview to easily see
}
