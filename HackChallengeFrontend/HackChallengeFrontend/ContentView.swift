//
//  ContentView.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//
//
//  ContentView.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = TaskViewModel()
    
    var completedCount: Int {
        viewModel.tasks.filter { $0.isCompleted }.count
    }
    
    var progress: Double {
        guard !viewModel.tasks.isEmpty else { return 0 }
        return Double(completedCount) / Double(viewModel.tasks.count)
    }
    
    var totalPoints: Int {
        viewModel.tasks.filter { $0.isCompleted }.reduce(0) { $0 + $1.points }
    }
    
    var sortedTasks: [StudyTask] {
        viewModel.tasks.sorted { lhs, rhs in
            if lhs.isCompleted == rhs.isCompleted {
                return lhs.name.lowercased() < rhs.name.lowercased()
            }
            return !lhs.isCompleted && rhs.isCompleted
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.vinylCream.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 12) {
                        
                        // header
                        VStack(spacing: 16) {
                            Text("tracklist")
                                .font(.system(size: 40, weight: .black))
                                .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                            Text("get into the groove")
                                .font(.system(size: 18, weight: .medium))
                                .italic()
                                .foregroundStyle(Color.vinylGold)
                        }
                        .padding(.bottom, 2)
                        
                        // ring — no isTimerRunning
                        RingProgressView(
                            progress: progress,
                            completed: completedCount,
                            total: viewModel.tasks.count
                        )
                        
                        // stats
                        HStack(spacing: 0) {
                            Spacer()
                            VStack(spacing: 2) {
                                Text("\(completedCount)")
                                    .font(.system(size: 28, weight: .black))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                                Text("done")
                                    .font(.system(size: 11, weight: .medium))
                                    .tracking(1)
                                    .foregroundStyle(Color.vinylGray)
                            }
                            Spacer()
                            Rectangle()
                                .fill(Color(red: 0.5, green: 0.45, blue: 0.4).opacity(0.2))
                                .frame(width: 1, height: 40)
                            Spacer()
                            VStack(spacing: 2) {
                                Text("\(viewModel.tasks.count - completedCount)")
                                    .font(.system(size: 28, weight: .black))
                                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.15))
                                Text("remain")
                                    .font(.system(size: 11, weight: .medium))
                                    .tracking(1)
                                    .foregroundStyle(Color.vinylGray)
                            }
                            Spacer()
                            Rectangle()
                                .fill(Color(red: 0.5, green: 0.45, blue: 0.4).opacity(0.2))
                                .frame(width: 1, height: 40)
                            Spacer()
                            VStack(spacing: 2) {
                                Text("\(totalPoints)")
                                    .font(.system(size: 28, weight: .black))
                                    .foregroundStyle(Color.vinylGold)
                                Text("points")
                                    .font(.system(size: 11, weight: .medium))
                                    .tracking(1)
                                    .foregroundStyle(Color.vinylGray)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 16)
                        .background(Color.vinylGold.opacity(0.15))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // your tracks header
                        HStack {
                            Text("YOUR TRACKS")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2)
                                .foregroundStyle(Color(red: 0.5, green: 0.45, blue: 0.4))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(Color.vinylGold)
                                .padding()
                        }
                        
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.horizontal)
                        }
                        
                        // task list
                        if sortedTasks.isEmpty && !viewModel.isLoading {
                            VStack(spacing: 8) {
                                Text("🎵")
                                    .font(.system(size: 40))
                                Text("no tracks yet")
                                    .font(.system(size: 13, weight: .medium))
                                    .tracking(1)
                                    .foregroundStyle(Color(red: 0.5, green: 0.45, blue: 0.4))
                            }
                            .padding(10)
                        } else {
                            ForEach(sortedTasks) { task in
                                TaskRowView(task: task, viewModel: viewModel)
                            }
                        }
                        
                        // add track button
                        NavigationLink {
                            TaskCreationView(viewModel: viewModel)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .bold))
                                Text("add track")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding(.top, 40)
                }
            }
            .onAppear {
                viewModel.fetchTasks()
            }
            .refreshable {
                viewModel.fetchTasks()
            }
        }
    }
}

#Preview {
    ContentView()
}
