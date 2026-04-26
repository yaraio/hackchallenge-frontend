//
//  ContentView.swift
//  HackChallengeFrontend
//
//  Created by Troy Corbitt on 4/26/26.
//
import SwiftUI

struct ContentView: View {
    
    @State private var tasks: [StudyTask] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Study App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Task creation flow")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
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
