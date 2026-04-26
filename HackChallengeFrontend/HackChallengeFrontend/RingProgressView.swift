import SwiftUI

struct RingProgressView: View {
    
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 18)
                .frame(width: 160, height: 160)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(.blue, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 160, height: 160)
            
            VStack {
                Text("\(Int(progress * 100))%")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Track Complete")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    RingProgressView(progress: 0.65)
}