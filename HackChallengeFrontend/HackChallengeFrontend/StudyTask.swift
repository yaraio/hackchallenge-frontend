import SwiftUI

struct StudyTask: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let priority: String
    let estimatedTime: Int
    let points: Int
    var isCompleted: Bool
}