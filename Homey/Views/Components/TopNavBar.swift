//
//  TopNavBar.swift
//  Homey
//
//  Created by Yoram on 03/06/26.
//

import SwiftUI

struct AddTaskView2: View {
    let title: String
    var onBack: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(0..<30) { i in
                        Text("Task item \(i + 1)")
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 8)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        onBack?()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                }
            }
        }
    }
}

struct NavFadeOverlay: View {
    var body: some View {
        GeometryReader { geo in
            let navHeight = geo.safeAreaInsets.top + 44

            Rectangle()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color(.systemBackground).opacity(1.0), location: 0.0),
                            .init(color: Color(.systemBackground).opacity(0.85), location: 0.6),
                            .init(color: Color(.systemBackground).opacity(0.0), location: 1.0),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: navHeight + 24) // extra 24pt fade tail
        }
        .frame(height: 0) // doesn't push content down
    }
}

#Preview {
    AddTaskView2(title: "Add Task")
}
