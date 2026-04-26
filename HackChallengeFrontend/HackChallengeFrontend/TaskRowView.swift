//
//  TaskRowView.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//


import SwiftUI

struct TaskRowView: View {
    
    @Binding var task: StudyTask
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(task.name)
                    .font(.headline)
                
                Text(task.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("\(task.priority) Priority • \(task.estimatedTime) hr • \(task.points) pts")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isCompleted ? .green : .gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .padding(.horizontal)
    }
}

#Preview {
    TaskRowView(task: .constant(
        StudyTask(
            name: "Read chapter 5",
            description: "Take notes on key ideas",
            priority: "High",
            estimatedTime: 2,
            points: 2,
            isCompleted: false
        )
    ))
}