import SwiftUI

struct PackView: View {
    @ObservedObject var viewModel: PlayableLevelListViewModel
    
    init(_ viewModel: PlayableLevelListViewModel) {
        self.viewModel = viewModel
    }
    
//    @State private var currentLevel: Int = 1
    let minLevel: Int = 1
    let maxLevel: Int = 10
    
    var body: some View {
        HStack {
            // Left Button (Decrease Level)
            Button(action: {
                if viewModel.packNumber > minLevel {
                    viewModel.packNumber -= 1
                }
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(viewModel.packNumber > minLevel ? .blue : .gray)
                    .padding()
            }
            .disabled(viewModel.packNumber == minLevel)
            
            // Current Level Display
            Text("Pack \(viewModel.packNumber)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(minWidth: 100)
            
            // Right Button (Increase Level)
            Button(action: {
                if viewModel.packNumber < maxLevel {
                    viewModel.packNumber += 1
                }
            }) {
                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(viewModel.packNumber < maxLevel ? .blue : .gray)
                    .padding()
            }
            .disabled(viewModel.packNumber == maxLevel)
        }
        .padding()
    }
}
