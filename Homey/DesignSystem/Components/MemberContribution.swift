//
//  MemberContribution.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 08/06/26.
//

import SwiftUI

struct MemberContributionItem: Identifiable {
    let id = UUID()
    let name: String
    let initials: String
    let taskCount: Int
}

struct MemberContribution: View {
    
    let items: [MemberContributionItem]

    var maxTask: Int {
        max(1, items.map { $0.taskCount }.max() ?? 1)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Member Contribution")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Task done this week")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 16) {
                ForEach(items) { member in
                    MemberRow(member: member, maxTask: maxTask)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
        .padding(.horizontal)
    }
}

struct MemberRow: View {
    let member: MemberContributionItem
    let maxTask: Int
    
    var progress: Double {
        Double(member.taskCount) / Double(maxTask)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.appPrimary)
                        .frame(width: 36, height: 36)
                    Text(member.initials)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text(member.name)
                    .font(.body)
                
                Spacer()
                
                Text("\(member.taskCount) Task")
                    .font(.body)
                    .fontWeight(.bold)
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appPrimary)
                        .frame(width: geo.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    MemberContribution(items: [
        MemberContributionItem(name: "Mom", initials: "MO", taskCount: 12),
        MemberContributionItem(name: "Dad", initials: "DA", taskCount: 8),
        MemberContributionItem(name: "Ana", initials: "AN", taskCount: 6),
        MemberContributionItem(name: "Ama", initials: "AM", taskCount: 4),
    ])
    .padding()
    .background(Color(.systemGroupedBackground))
}
