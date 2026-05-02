//
//  TaskViewModel.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 5/1/26.
//


import Foundation
import Combine

class TaskViewModel: ObservableObject {
    
    @Published var tasks: [StudyTask] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let userId = 1
    
    func fetchTasks() {
        isLoading = true
        errorMessage = ""
        
        NetworkManager.shared.getTasks(userId: userId) { tasks in
            DispatchQueue.main.async {
                self.tasks = tasks
                self.isLoading = false
            }
        }
    }
    
    func createTask(title: String, description: String, priority: String, durationMinutes: Int) {
        isLoading = true
        errorMessage = ""
        
        NetworkManager.shared.createTask(
            userId: userId,
            title: title,
            description: description,
            priority: StudyTask.priorityValue(from: priority),
            durationMinutes: durationMinutes
        ) { task in
            DispatchQueue.main.async {
                if let task = task {
                    self.tasks.append(task)
                } else {
                    self.errorMessage = "Could not create task."
                }
                self.isLoading = false
            }
        }
    }
    
    func completeTask(_ task: StudyTask) {
        NetworkManager.shared.completeTask(taskId: task.id) { updatedTask in
            DispatchQueue.main.async {
                if let updatedTask = updatedTask {
                    if let index = self.tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                        self.tasks[index] = updatedTask
                    }
                } else {
                    self.errorMessage = "Could not complete task."
                }
            }
        }
    }
    
    func deleteTask(_ task: StudyTask) {
        NetworkManager.shared.deleteTask(taskId: task.id) { success in
            DispatchQueue.main.async {
                if success {
                    self.tasks.removeAll { $0.id == task.id }
                } else {
                    self.errorMessage = "Could not delete task."
                }
            }
        }
    }
    
    func updateTaskLocally(_ updatedTask: StudyTask) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
        }
    }
}
