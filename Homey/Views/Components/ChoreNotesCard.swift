//
//  ChoreNotesCard.swift
//  Homey
//
//  Created by Yoram on 05/06/26.
//

import SwiftUI

struct ChoreNotesCard: View {
    let notes: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(spacing: 6) {
                Image(systemName: "doc.text")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textYellow)

                Text("Notes")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textYellow)
            }

            // Notes text
            Text(notes)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.textYellow)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.taskYellow)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    ChoreNotesCard(notes: "Don't forget to change the bedsheets and mop the floor ya.")
        .padding()
}
