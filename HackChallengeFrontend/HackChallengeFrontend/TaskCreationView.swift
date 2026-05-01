//
//  TaskCreationView.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//


import SwiftUI

struct TaskCreationView: View {
    
    @Binding var tasks: [StudyTask]
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var priority = "medium"
    @State private var estimatedTime = 1
    
    let priorities = ["low", "medium", "high"]
    
    var points: Int {
        estimatedTime
    }
    
    var body: some View {
        ZStack {
            Color.vinylCream.ignoresSafeArea()
            Form {
                Section("task info") {
                    TextField("task name", text: $name)
                    TextField("description", text: $description)
                    
                    Picker("priority", selection: $priority) {
                        ForEach(priorities, id: \.self) { priority in
                            Text(priority)
                        }
                    }
                    
                    Stepper("estimated time: \(estimatedTime) hour(s)", value: $estimatedTime, in: 1...10)
                    
                    Text("points: \(points)")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.vinylGold)
                }
                
                Section {
                    Button("add task") {
                        let newTask = StudyTask(
                            name: name,
                            description: description,
                            priority: priority,
                            estimatedTime: estimatedTime,
                            points: points,
                            isCompleted: false
                        )
                        
                        tasks.append(newTask)
                        dismiss()
                    }
                    .disabled(name.isEmpty || description.isEmpty)
                    .foregroundStyle(Color.vinylGold)
                }
            }
            .tint(Color.vinylGold)
            .scrollContentBackground(.hidden)

        }
        .navigationTitle("create task")
        .navigationBarTitleDisplayMode(.inline)
        //.background(Color.vinylCream.ignoresSafeArea())
        //.foregroundStyle(Color.gardenGreen)
    }
}

#Preview {
    NavigationStack {
        TaskCreationView(tasks: .constant([]))
    }
}
