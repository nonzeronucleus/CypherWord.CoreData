import SwiftUI

struct CartoonButton: View {
    var levelNumber: Int
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(levelNumber)")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 80, height: 80) // Makes the button square
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.cyan]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.black, lineWidth: 4)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.6), Color.clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 5)
        }
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.2), value: 1.0)
        .buttonStyle(PlainButtonStyle())
    }
}

struct CartoonButton_Previews: PreviewProvider {
    static var previews: some View {
        CartoonButton(levelNumber: 1) {
            print("Level 1 Selected")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
