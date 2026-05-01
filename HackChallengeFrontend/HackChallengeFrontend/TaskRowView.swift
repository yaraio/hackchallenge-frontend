//
//  TaskRowView.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//


import SwiftUI

struct TaskRowView: View {
    
    @Binding var task: StudyTask
    
    var priorityColor: Color {
        switch task.priority {
        case "high": return .red
        case "medium": return .orange
        default: return Color.vinylGold
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(priorityColor)
                        .frame(width: 8, height: 8)
                    Text(task.name)
                        .font(.headline)
                        .foregroundStyle(task.isCompleted ? Color.gray : Color(red: 0.15, green: 0.15, blue: 0.15))
                        .strikethrough(task.isCompleted)
                }
                Text(task.description)
                    .font(.subheadline)
                    .foregroundStyle(Color.vinylGray)
                Text("\(task.priority) priority • \(task.estimatedTime) hr • \(task.points) pts")
                    .font(.caption)
                    .foregroundStyle(Color.vinylGray)
            }
            
            Spacer()
            
            // simple button, no overlay
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isCompleted ? Color.vinylGold : Color.vinylGold.opacity(0.4))
            }
            .buttonStyle(.plain) // 👈 removes the default box/background
        }
        .padding()
        .background(task.isCompleted ? Color.vinylGold.opacity(0.1) : Color.vinylCream)
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
