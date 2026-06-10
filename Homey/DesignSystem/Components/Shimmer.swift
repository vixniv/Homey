//
//  Shimmer.swift
//  Homey
//
//  Reusable shimmer for skeleton placeholders. Use with `.redacted(reason: .placeholder)`.
//

import SwiftUI

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [.white.opacity(0), .white.opacity(0.55), .white.opacity(0)],
                        startPoint: .leading, endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 1.4)
                    .offset(x: phase * geo.size.width * 1.4)
                    .blendMode(.plusLighter)
                }
                .allowsHitTesting(false)
            )
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmering() -> some View { modifier(Shimmer()) }
}

/// A skeleton stand-in shaped like a TaskCard.
struct SkeletonCard: View {
    var body: some View {
        TaskCard(
            task: TaskItem(
                id: UUID().uuidString, choreId: UUID(), occurrenceDate: nil,
                title: "Loading task name", dueLabel: "Before 0:00 AM", state: .available
            ),
            onGrab: {}
        )
        .redacted(reason: .placeholder)
        .shimmering()
        .allowsHitTesting(false)
    }
}
