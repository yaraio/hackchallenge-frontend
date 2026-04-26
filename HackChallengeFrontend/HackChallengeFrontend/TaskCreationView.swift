import SwiftUI

struct TaskCreationView: View {
    
    @Binding var tasks: [StudyTask]
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var priority = "Medium"
    @State private var estimatedTime = 1
    
    let priorities = ["Low", "Medium", "High"]
    
    var points: Int {
        estimatedTime
    }
    
    var body: some View {
        Form {
            Section("Task Info") {
                TextField("Task Name", text: $name)
                TextField("Description", text: $description)
                
                Picker("Priority", selection: $priority) {
                    ForEach(priorities, id: \.self) { priority in
                        Text(priority)
                    }
                }
                
                Stepper("Estimated Time: \(estimatedTime) hour(s)", value: $estimatedTime, in: 1...10)
                
                Text("Points: \(points)")
                    .fontWeight(.semibold)
            }
            
            Section {
                Button("Add Task") {
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
            }
        }
        .navigationTitle("Create Task")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TaskCreationView(tasks: .constant([]))
    }
}