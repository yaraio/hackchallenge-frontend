//
//  RingProgressView.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//

import SwiftUI

struct RingProgressView: View {
    let progress: Double
    let completed: Int
    let total: Int
    
    @State private var rotation: Double = 0
    @State private var showNote1 = false
    @State private var showNote2 = false
    @State private var showNote3 = false
    
    var isComplete: Bool {
        total > 0 && completed == total
    }
    
    var body: some View {
        ZStack {
            // needle
            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(red: 0.75, green: 0.75, blue: 0.75))
                    .frame(width: 3, height: 80)
                    .rotationEffect(.degrees(-35), anchor: .top)
                    .offset(x: -130, y: -80)
                Circle()
                    .fill(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .frame(width: 10, height: 10)
                    .offset(x: -130, y: -120)
            }
            
            // vinyl
            ZStack {
                // disk
                Circle()
                    .fill(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .frame(width: 260, height: 260)
                
                // grooves
                ForEach(0..<5) { i in
                    Circle()
                        .stroke(Color.white.opacity(0.04), lineWidth: 1)
                        .frame(width: CGFloat(240 - i * 22), height: CGFloat(240 - i * 22))
                }
                
                // background arc
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 14)
                    .frame(width: 240, height: 240)
                
                // progress arc
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.vinylGold, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 240, height: 240)
                    .animation(.easeInOut(duration: 0.6), value: progress)
                
                // gold label
                Circle()
                    .fill(Color.vinylGold)
                    .frame(width: 90, height: 90)
                
                // center text
                if isComplete {
                    Text("✓")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(.black.opacity(0.7))
                } else {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(.black.opacity(0.7))
                }
                
                // music notes
                ZStack {
                    if showNote1 {
                        Text("♪")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.vinylGold)
                            .modifier(FlyingNoteModifier(x: -40, y: -70))
                    }
                    if showNote2 {
                        Text("♫")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.vinylGold.opacity(0.8))
                            .modifier(FlyingNoteModifier(x: 40, y: -60))
                    }
                    if showNote3 {
                        Text("♩")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.vinylGold.opacity(0.6))
                            .modifier(FlyingNoteModifier(x: 0, y: -80))
                    }
                }
            }
            // 👇 only spins on task complete, nothing else
            .rotationEffect(.degrees(rotation))
            .onChange(of: completed) {
                guard completed > 0 else { return }
                withAnimation(.easeIn(duration: 0.4)) {
                    rotation += 60
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.linear(duration: 0.6)) {
                        rotation += 300
                    }
                }
                showNote1 = true
                showNote2 = true
                showNote3 = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                    showNote1 = false
                    showNote2 = false
                    showNote3 = false
                }
            }
        }
        .padding()
    }
}

struct FlyingNoteModifier: ViewModifier {
    let x: CGFloat
    let y: CGFloat
    @State private var animate = false
    @State private var opacity: Double = 1.0
    
    func body(content: Content) -> some View {
        content
            .offset(x: animate ? x : 0, y: animate ? y : 0)
            .opacity(opacity)
            .scaleEffect(animate ? 1.4 : 0.8)
            .onAppear {
                withAnimation(.easeOut(duration: 1.5)) {
                    animate = true
                }
                withAnimation(.easeIn(duration: 0.8).delay(1.2)) {
                    opacity = 0
                }
            }
    }
}

#Preview {
    ZStack {
        Color.vinylCream.ignoresSafeArea()
        RingProgressView(progress: 0.65, completed: 4, total: 6)
    }
}
// https://developer.apple.com/documentation/swiftui/shape/trim%28from%3Ato%3A%29
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics/
