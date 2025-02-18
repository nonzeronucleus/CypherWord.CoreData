import SwiftUI

struct PercentageCircleView: View {
    var percentage: Double // Value between 0 and 1 (e.g., 0.25 for 25%)
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 10) // Background circle
            
            Circle()
                .trim(from: 0.0, to: CGFloat(percentage)) // Trim based on percentage
                .stroke(Color.red.opacity(0.3), lineWidth: 10)
                .rotationEffect(.degrees(-90)) // Rotate so it starts from the top
        }
        .frame(width: 50, height: 50) // Adjust size as needed
    }
}
