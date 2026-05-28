//
//  TimePicker.swift
//  Scoers
//
//  Created by Nadila Rizky Amelia on 28/05/26.
//

//
//  TimePicker.swift
//  Scoers
//
//  Created by Nadila Rizky Amelia on 28/05/26.
//

import SwiftUI

struct TimePicker: View {
    @Binding var selectedTime: Date
    var color: Color = Color(red: 124/255, green: 196/255, blue: 240/255)
    @State private var showPicker = false

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh : mm a"
        return formatter.string(from: selectedTime)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Must be Done by")
                .font(.system(size: 14, weight: .regular))

            Button { showPicker.toggle() } label: {
                HStack {
                    Text(formattedTime)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "clock")
                        .foregroundColor(.primary)
                }
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(color))
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showPicker) {
            VStack {
                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                Button("Done") { showPicker = false }
                    .padding(.bottom)
            }
            .presentationDetents([.height(300)])
        }
    }
}

#Preview {
    @Previewable @State var time = Date()
    TimePicker(selectedTime: $time)
}
