//
//  ContentView.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//
import SwiftUI

struct ContentView: View {
    
    @State private var tasks: [StudyTask] = []
    
    var completedCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var progress: Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(completedCount) / Double(tasks.count)
    }
    
    var totalPoints: Int {
        tasks.filter { $0.isCompleted}.reduce(0) { $0 + $1.points }
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Study App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Task creation flow")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                RingProgressView(progress: progress, completed: completedCount, total: tasks.count)
                
                HStack(spacing: 0){
                    Spacer()
                    VStack(spacing: 4){
                        Text("\(completedCount)")
                            .font(.title2).fontWeight(.bold)
                        Text("Done")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(spacing: 4) {
                        Text("\(tasks.count-completedCount)")
                            .font(.title2).fontWeight(.bold)
                        Text("Left")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(spacing: 4) {
                        Text("\(totalPoints)")
                            .font(.title2).fontWeight(.bold).foregroundStyle(.blue)
                        Text("Points")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                if tasks.isEmpty {
                    VStack(spacing: 10) {
                        //Image(systemName: "checklist")
                            //.font(.system(size:40))
                            //.foregroundStyle(.secondary)
                        Text("No tasks created yet - add one!")
                            .foregroundStyle(.secondary)
                    }
                    .padding(40)
                } else {
                    ForEach($tasks) { $task in TaskRowView(task: $task)
                        
                    }
                }
                
                NavigationLink {
                    TaskCreationView(tasks: $tasks)
                } label: {
                    Text("Create Task")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 40)
        }
    }
}

#Preview {
    ContentView()
}

// scrollable
