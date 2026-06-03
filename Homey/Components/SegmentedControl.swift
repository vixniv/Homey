//
//  SegmentedControl.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct SegmentedControl: View {
    @Binding var selection: ChoreViewMode //selection
    
    let cornerRadius: Double = 30
    
    let color1: Color = Color(.gray.opacity(0.2))
    let color2: Color = Color(.white)
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundStyle(color1)
                
            HStack {
                Button {
                    selection = .all
                } label: {
                    ZStack {
                        if selection == .all {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundStyle(color2)
                        }
                        
                        Text("Household chores")
                            .bold()
                            .foregroundStyle(.black)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                }
                Button {
                    selection = .myself
                } label: {
                    ZStack {
                        if selection == .myself {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundStyle(color2)
                        }
                        
                        Text("My chores")
                            .bold()
                            .foregroundStyle(.black)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(2)
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 35)
    }
}

#Preview {
    @Previewable @State var selectedItem: ChoreViewMode = .all
    
    SegmentedControl(selection: $selectedItem)
        .padding()
}

#Preview {
    ContentView()
}
