import SwiftUI

struct LevelButtonView: View {
    let number: Int
    let gradient: Gradient
    var action: () -> Void
    
    init(number: Int, gradient: Gradient = Gradient(colors: [Color.orange, Color.red]), action: @escaping () -> Void) {
        self.number = number
        self.gradient = gradient
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                // Background button shape
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        gradient: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black.opacity(0.5), lineWidth: 2) // Thin dark border
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                
                // 3D inset effect
                Circle()
                //            RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.3), Color.white.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 64, height: 64)
                    .offset(y: 0)
                    .blendMode(.multiply)
                
                // Level number
                Text("\(number)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 1, y: 1)
            }
            .frame(width: 80, height: 90)
        }
    }
}

struct LevelButton_Previews: PreviewProvider {
    static var previews: some View {
        LevelButtonView(number: 88) {
            
        }
    }
}
