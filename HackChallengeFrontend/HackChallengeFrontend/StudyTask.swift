//
//  StudyTask.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//

import SwiftUI

struct StudyTask: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let priority: String
    let estimatedTime: Double
    let points: Int
    var isCompleted: Bool
}
