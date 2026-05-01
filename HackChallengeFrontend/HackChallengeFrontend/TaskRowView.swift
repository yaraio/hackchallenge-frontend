//
//  TaskRowView.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//

import SwiftUI

struct TaskRowView: View {
    
    @Binding var task: StudyTask
    @Binding var tasks: [StudyTask]
    
    @State private var isExpanded = true
    @State private var isPlaying = true
    @State private var timer: Timer? = nil
    @State private var showTimerAlert = false
    @State private var scratchOffset: Double = 0
    @State private var isScratchAnimating = false
    @State private var navigateToEdit = false
    
    @State private var elapsedSecondsTracked: Double = 0
    @State private var totalSecondsTracked: Double = 0
    
    var playbackProgress: Double {
        guard totalSecondsTracked > 0 else { return 0 }
        return elapsedSecondsTracked / totalSecondsTracked
    }
    var elapsedSeconds: Double { elapsedSecondsTracked }
    var remainingSeconds: Double { totalSecondsTracked - elapsedSecondsTracked }
    
    var priorityColor: Color {
        switch task.priority {
        case "high": return .red
        case "medium": return .yellow
        default: return Color.vinylGold
        }
    }
    
    func formatTime(_ hours: Double) -> String {
        if hours == 0.5 { return "30min" }
        if hours.truncatingRemainder(dividingBy: 1) == 0 { return "\(Int(hours))hr" }
        return "\(Int(hours))hr 30min"
    }
    
    func formatSeconds(_ s: Double) -> String {
        let mins = Int(s) / 60
        let secs = Int(s) % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Main row
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(priorityColor)
                            .frame(width: 8, height: 8)
                        Text(task.name)
                            .font(.headline)
                            .foregroundStyle(task.isCompleted ? Color.gray : Color(red: 0.15, green: 0.15, blue: 0.15))
                            .strikethrough(task.isCompleted)
                    }
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundStyle(Color.vinylGray)
                    HStack(spacing: 6) {
                        Text("\(task.priority) priority")
                            .font(.caption)
                            .foregroundStyle(Color.vinylGray)
                        Text("•")
                            .font(.caption)
                            .foregroundStyle(Color.vinylGray)
                        Text(formatTime(task.estimatedTime))
                            .font(.caption)
                            .foregroundStyle(Color.vinylGray)
                        Text("•")
                            .font(.caption)
                            .foregroundStyle(Color.vinylGray)
                        Text("\(task.points) pts")
                            .font(.caption)
                            .foregroundStyle(Color.vinylGray)
                    }
                }
                
                Spacer()
                
                // chevron
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.vinylGold.opacity(0.6))
                }
                .buttonStyle(.plain)
                
                // checkmark
                Button {
                    task.isCompleted.toggle()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    if !task.isCompleted {
                        stopTimer()
                        elapsedSecondsTracked = 0
                    }
                } label: {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundStyle(task.isCompleted ? Color.vinylGold : Color.vinylGold.opacity(0.4))
                }
                .buttonStyle(.plain)
            }
            .padding()
            
            // MARK: Expanded player
            if isExpanded && !task.isCompleted {
                VStack(spacing: 12) {
                    
                    // scrub bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.vinylGold.opacity(0.15))
                                .frame(height: 4)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.vinylGold)
                                .frame(width: geo.size.width * playbackProgress, height: 4)
                            
                            Circle()
                                .fill(Color.vinylGold)
                                .frame(width: 12, height: 12)
                                // 👇 scratchOffset added here
                                .offset(x: geo.size.width * playbackProgress - 6 + scratchOffset)
                        }
                        // 👇 drag scrubs by setting elapsedSecondsTracked directly
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let newProgress = min(max(value.location.x / geo.size.width, 0), 1.0)
                                    elapsedSecondsTracked = newProgress * totalSecondsTracked
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                }
                        )
                    }
                    .frame(height: 12)
                    
                    // time labels
                    HStack {
                        Text(formatSeconds(elapsedSeconds))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color.vinylGray)
                        Spacer()
                        Text("-\(formatSeconds(remainingSeconds))")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color.vinylGray)
                    }
                    
                    // controls
                    HStack(spacing: 24) {
                        // rewind
                        Button(action: {
                            elapsedSecondsTracked = 0
                            if isPlaying { startTimer() }
                        }) {
                            Image(systemName: "backward.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.vinylGold.opacity(0.6))
                        }
                        .buttonStyle(.plain)
                        
                        // play/pause
                        Button(action: {
                            isPlaying.toggle()
                            if isPlaying { startTimer() } else { stopTimer() }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.vinylGold)
                                    .frame(width: 44, height: 44)
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color.vinylDark)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        // fast forward
                        Button(action: {
                            elapsedSecondsTracked = min(elapsedSecondsTracked + (totalSecondsTracked * 0.1), totalSecondsTracked)
                        }) {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.vinylGold.opacity(0.6))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            
            
        }
        
        .navigationDestination(isPresented: $navigateToEdit) {
            TaskCreationView(tasks: $tasks, existingTask: task)
        }
        
        .onAppear {
            totalSecondsTracked = task.estimatedTime * 3600
            elapsedSecondsTracked = 0
            if !task.isCompleted && isExpanded {
                isPlaying = true
                startTimer()
            }
        }
        .onDisappear {
            stopTimer()
        }
        .background(task.isCompleted ? Color.vinylGold.opacity(0.1) : Color.vinylCream)
        .cornerRadius(14)
        .padding(.horizontal)
        .sheet(isPresented: $showTimerAlert) {
            ZStack {
                Color.vinylCream.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("🎵")
                        .font(.system(size: 40))
                    Text("time's up")
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(Color.vinylDark)
                    Text("you spent \(formatTime(task.estimatedTime)) on \(task.name)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.vinylGray)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 10) {
                        Button {
                            task.isCompleted = true
                            showTimerAlert = false
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                        } label: {
                            Text("✓  mark complete")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color.vinylDark)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.vinylGold)
                                .cornerRadius(14)
                        }
                        
                        // +30 min — resumes, doesn't restart
                        Button {
                            totalSecondsTracked += 1800
                            isPlaying = true
                            startTimer()
                            showTimerAlert = false
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        } label: {
                            Text("+ 30 min")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color.vinylGold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.vinylGold.opacity(0.12))
                                .cornerRadius(14)
                        }
                        
                        // edit task
                        Button {
                            showTimerAlert = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                navigateToEdit = true
                            }
                        } label: {
                            Text("edit task")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Color.vinylGold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.vinylGold.opacity(0.12))
                                .cornerRadius(14)
                        }
                        
                        // ignore
                        Button {
                            elapsedSecondsTracked = 0
                            isPlaying = true
                            startTimer()
                            showTimerAlert = false
                        } label: {
                            Text("keep going")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.vinylGray)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(32)
            }
            .presentationDetents([.medium])
        }
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if elapsedSecondsTracked >= totalSecondsTracked - 0.5 {
                elapsedSecondsTracked = totalSecondsTracked
                stopTimer()
                isPlaying = false
                triggerRecordScratch()
            } else {
                elapsedSecondsTracked += 1
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func triggerRecordScratch() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        isScratchAnimating = true
        withAnimation(.easeOut(duration: 0.08)) { scratchOffset = -15 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.easeOut(duration: 0.08)) { scratchOffset = 12 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            withAnimation(.easeOut(duration: 0.08)) { scratchOffset = -8 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
            withAnimation(.easeOut(duration: 0.08)) { scratchOffset = 5 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
            withAnimation(.easeOut(duration: 0.08)) { scratchOffset = 0 }
            isScratchAnimating = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showTimerAlert = true
        }
    }
}

#Preview {
    NavigationStack {
        TaskRowView(
            task: .constant(
                StudyTask(
                    name: "Read chapter 5",
                    description: "Take notes on key ideas",
                    priority: "high",
                    estimatedTime: 1.0,
                    points: 1,
                    isCompleted: false
                )
            ),
            tasks: .constant([])
        )
    }
}
