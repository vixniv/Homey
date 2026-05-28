//
//  SegmentedControl.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct SegmentedControl: View {
    @Binding var selection: ChoreViewMode //selection
    
    let cornerRadius: Double = 15
    
    let color1: Color = Color("AppPrimaryColor")
    let color2: Color = Color("AppSecondaryColor")
    
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
                        } else {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundStyle(color1)
                        }
                        
                        Text("Household")
                            .foregroundStyle(.black)
                    }
                }
                Button {
                    selection = .myself
                } label: {
                    ZStack {
                        if selection == .myself {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundStyle(color2)
                        } else {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundStyle(color1)
                        }
                        
                        Text("My chores")
                            .foregroundStyle(.black)
                    }
                }
            }
            .padding(2)
            
        }
        .frame(width: .infinity, height:50)
    }
}

#Preview {
    @Previewable @State var selectedItem: ChoreViewMode = .all
    
    SegmentedControl(selection: $selectedItem)
        .padding()
}
