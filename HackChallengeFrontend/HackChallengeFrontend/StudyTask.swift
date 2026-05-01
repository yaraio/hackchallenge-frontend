//
//  StudyTask.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//
import SwiftUI

struct StudyTask: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let description: String
    let priority: Int
    let duration_minutes: Int
    let user_id: Int
    var completed: Bool
    let date_started: String?
    
    var name: String {
        title
    }
    
    var isCompleted: Bool {
        completed
    }
    
    var estimatedTime: Double {
        Double(duration_minutes) / 60.0
    }
    
    var points: Int {
        max(Int(estimatedTime) + priority / 5, 1)
    }
    
    var priorityLabel: String {
        if priority >= 8 {
            return "high"
        } else if priority >= 4 {
            return "medium"
        } else {
            return "low"
        }
    }
    
    var priorityText: String {
        priorityLabel
    }
    
    init(
        id: Int = 0,
        name: String,
        description: String,
        priority: String,
        estimatedTime: Double,
        points: Int = 0,
        isCompleted: Bool,
        userId: Int = 1,
        dateStarted: String? = nil
    ) {
        self.id = id
        self.title = name
        self.description = description
        self.priority = StudyTask.priorityValue(from: priority)
        self.duration_minutes = Int(estimatedTime * 60)
        self.user_id = userId
        self.completed = isCompleted
        self.date_started = dateStarted
    }
    
    static func priorityValue(from label: String) -> Int {
        switch label.lowercased() {
        case "high":
            return 8
        case "medium":
            return 5
        default:
            return 2
        }
    }
}
