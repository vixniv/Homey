//
//  ChoreHouseLabel.swift
//  Homey
//
//  Created by Yoram on 05/06/26.
//

import SwiftUI

struct ChoreHouseLabel: View {
    let houseName: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "house")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)

            Text(houseName)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ChoreHouseLabel(houseName: "Ana's Family House")
}
