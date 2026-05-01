//
//  TaskCreationView.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//

import SwiftUI

struct TaskCreationView: View {
    
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    var existingTask: StudyTask? = nil
    
    @State private var name: String
    @State private var description: String
    @State private var priority: String
    @State private var estimatedTime: Double
    
    init(viewModel: TaskViewModel, existingTask: StudyTask? = nil) {
        self.viewModel = viewModel
        _name = State(initialValue: existingTask?.name ?? "")
        _description = State(initialValue: existingTask?.description ?? "")
        _priority = State(initialValue: existingTask?.priorityLabel ?? "medium")
        _estimatedTime = State(initialValue: existingTask?.estimatedTime ?? 0.5)
        self.existingTask = existingTask
    }
    
    let priorities = ["low", "medium", "high"]
    
    var points: Int {
        Int(estimatedTime * 2)
    }
    
    var body: some View {
        ZStack {
            Color.vinylCream.ignoresSafeArea()
            Form {
                Section("track info") {
                    TextField("task name", text: $name)
                    TextField("description", text: $description)
                    
                    Picker("priority", selection: $priority) {
                        ForEach(priorities, id: \.self) { p in
                            Text(p)
                        }
                    }
                    
                    HStack {
                        Text("estimated time")
                            .foregroundStyle(Color.black)
                        Spacer()
                        Button(action: {
                            if estimatedTime > 0.5 { estimatedTime -= 0.5 }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(estimatedTime > 0.5 ? Color.vinylGold : Color.vinylGold.opacity(0.3))
                        }
                        .buttonStyle(.plain)
                        
                        Text(estimatedTime == 0.5 ? "30 min" : estimatedTime.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(estimatedTime)) hr" : "\(Int(estimatedTime)) hr 30 min")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.vinylDark)
                            .frame(minWidth: 80, alignment: .center)
                        
                        Button(action: {
                            if estimatedTime < 8.0 { estimatedTime += 0.5 }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(estimatedTime < 8.0 ? Color.vinylGold : Color.vinylGold.opacity(0.3))
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Text("♪  \(points) pts")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.vinylGold)
                }
                
                Section {
                    Button(existingTask == nil ? "add task" : "save changes") {
                        if let existingTask = existingTask {
                            let updatedTask = StudyTask(
                                id: existingTask.id,
                                name: name,
                                description: description,
                                priority: priority,
                                estimatedTime: estimatedTime,
                                points: points,
                                isCompleted: existingTask.isCompleted,
                                userId: existingTask.user_id,
                                dateStarted: existingTask.date_started
                            )
                            viewModel.updateTaskLocally(updatedTask)
                        } else {
                            viewModel.createTask(
                                title: name,
                                description: description,
                                priority: priority,
                                durationMinutes: Int(estimatedTime * 60)
                            )
                        }
                        dismiss()
                    }
                    .disabled(name.isEmpty || description.isEmpty)
                    .foregroundStyle(Color.vinylGold)
                    
                    if existingTask != nil {
                        Button("delete task", role: .destructive) {
                            if let existingTask = existingTask {
                                viewModel.deleteTask(existingTask)
                            }
                            dismiss()
                        }
                    }
                }
            }
            .tint(Color.vinylGold)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(existingTask == nil ? "create task" : "edit task")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TaskCreationView(viewModel: TaskViewModel())
    }
}
