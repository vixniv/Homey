//
//  HeaderTitle.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

// TODO: Review — currently unused; the home header is rendered via navigationTitle. Revisit during the UI pass.
struct HeaderTitle: View {
    var name: String // name of the household member
    let date: Date = Date.now

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
    RootView()
}
