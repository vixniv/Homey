//
//  DaySelector.swift
//  Scoers
//
//  Created by Nadila Rizky Amelia on 29/05/26.
//

import SwiftUI

struct DaySelector: View {
    let days = ["S","M","T","W","T","F","S"]
    @Binding var selected: Set<Int>
    var color: Color = .appPrimary

    var body: some View {
        HStack(spacing: 8) {
            ForEach(days.indices, id: \.self) { i in
                Text(days[i])
                    .frame(width: 44, height: 44)
                    .background(selected.contains(i) ? color : Color.gray.opacity(0.2))
                    .clipShape(Circle())
                    .onTapGesture {
                        if selected.contains(i) {
                            selected.remove(i)
                        } else {
                            selected.insert(i)
                        }
                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var selected: Set<Int> = []
    DaySelector(selected: $selected)
}
