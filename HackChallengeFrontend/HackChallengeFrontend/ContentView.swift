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
        tasks.filter { $0.isCompleted }.reduce(0) { $0 + $1.points }
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
                            total: tasks.count
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
                                Text("\(tasks.count - completedCount)")
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
                        
                        // task list
                        if tasks.isEmpty {
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
                            ForEach($tasks.sorted(by: { !$0.isCompleted.wrappedValue && $1.isCompleted.wrappedValue })) { $task in
                                TaskRowView(task: $task, tasks: $tasks)
                            }
                            .onDelete { indexSet in
                                tasks.remove(atOffsets: indexSet)
                            }
                        }
                        
                        // add track button
                        NavigationLink {
                            TaskCreationView(tasks: $tasks)
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
        }
    }
}

#Preview {
    ContentView()
}
// scrollable
