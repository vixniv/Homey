//
//  DatePicker.swift
//  Scoers
//
//  Created by Nadila Rizky Amelia on 28/05/26.
//

import SwiftUI

struct DatePickerField: View {
    @Binding var selectedDate: Date
    var color: Color = Color(red: 124/255, green: 196/255, blue: 240/255)
    
    @State private var showDatePicker = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd / MM / yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Date")
                .font(.system(size: 14, weight: .regular))
            
            Button(action: {
                showDatePicker.toggle()
            }) {
                HStack {
                    Text(dateFormatter.string(from: selectedDate))
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .foregroundColor(.primary)
                }
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color)
                )
            }
            
            if showDatePicker {
                SwiftUI.DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(color)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    DatePickerField(selectedDate: .constant(Date()))
}
