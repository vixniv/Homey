//
//  ProgressBar.swift
//  ChoreManagementApp
//
//  Created by Muhammad Saleh Bagir Alatas on 28/05/26.
//

import SwiftUI

struct ProgressBar: View {
    @State var taskCount: Int
    @State var completedTaskCount: Int
    
    var uncompletedTaskCount: Int {
        taskCount - completedTaskCount
    }
    
    var cornerRadius: Double = 10
    var color1 = Color("PastelRed")
    var color2 = Color("AppPrimaryColor")
    var height: Double = 20
    
    var body: some View {
        if taskCount >= completedTaskCount {
            VStack(alignment: .leading) {
                Text("\(completedTaskCount) of \(taskCount) chores have been done today")
                    .foregroundStyle(.gray)
                
                // Progress bar: basically it's stacking rectangles in a HStack
                ZStack {
                    // background rectangle
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundStyle(color2)
                    
                    HStack(spacing: 0){
                        // completed tasks
                        ForEach(0..<completedTaskCount, id: \.self) {i in
                            if i == completedTaskCount - 1 {
                                // if it the last rectangle, add corner radius to right side corners
                                UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: cornerRadius, topTrailing: cornerRadius))
                                    .foregroundStyle(color1)
                            }else {
                                // if it is not the last rectangle, don't add corner radius
                                Rectangle()
                                    .foregroundStyle(color1)
                            }
                        
                        }
                        
                        // uncompleted tasks
                        ForEach(0..<uncompletedTaskCount, id: \.self) {i in
                            Rectangle()
                                .foregroundStyle(color2)
                        }
                    }
                    
                }
                .frame(width: .infinity, height: height)
                .cornerRadius(cornerRadius)
            }
        } else {
            fatalError("Completed task is than number of task")
        }
    }
}

#Preview {
    ProgressBar(taskCount: 21, completedTaskCount: 20)
        .padding()
}

#Preview {
    ContentView(selectedTabItem: .home)
}
