//
//  SegmentedControl.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

// TODO: Review — reimplements Picker(.segmented); replace the NotificationView usage with the native control.
struct SegmentedControl: View {
    @Binding var selectedIndex: Int
    let options: [String]
    let cornerRadius: Double = 30
    
    let color1: Color = Color(.gray.opacity(0.1))
    let color2: Color = Color(.appPrimary)
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundStyle(color1)
                
            HStack {
                ForEach(options.indices, id: \.self) { index in
                    Button {
                        selectedIndex = index
                    } label: {
                        ZStack {
                            if selectedIndex == index {
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .foregroundStyle(color2)
                                Text(options[index])
                                    .foregroundStyle(Color.white)
                            }
                            
                            if selectedIndex == index {
                                Text(options[index])
                                    .foregroundStyle(Color.white)
                                    .bold()
                            } else {
                                Text(options[index])
                                    .bold()
                                    .foregroundStyle(.black .opacity(0.7))
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 35)
    }
}

#Preview {
    @Previewable @State var selected = 0
    
    SegmentedControl(selectedIndex: $selected, options: ["All", "Unread"])
        .padding()
}

#Preview {
    RootView()
}
