import SwiftUI
import Dependencies

struct LevelListView : View {
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var showThoughtsView = false
    @ObservedObject var viewModel: LevelListViewModel
    init(_ viewModel: LevelListViewModel) {
        self.viewModel = viewModel
    }
    
    var primaryColor: Color {
        viewModel.levelType == .layout ? .green : .blue
    }
    
    var secondaryColor: Color {
        viewModel.levelType == .layout ? .teal : .cyan
    }
    
    var body: some View {
        VStack {
            Text(viewModel.levelType.rawValue)
                .frame(maxWidth: .infinity)
                .padding(CGFloat(integerLiteral: 20))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .background(primaryColor)
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    let levels = viewModel.levels
                    ForEach(levels) { level in
                        CartoonButton(levelNumber:level.number, gradient:Gradient(colors: [primaryColor, secondaryColor])) {
                            viewModel.onSelectLevel(level: level)
                        }
                    }
                }
            }

            if viewModel.levelType == .layout {
                Button("Add") {
                    viewModel.addLayout()
                }
            }
            Button("Delete all") {
                viewModel.deleteAll()
            }
            Button("Export") {
                viewModel.exportAll()
            }
            Spacer()
        }
        .tabItem {
            Image(systemName: viewModel.levelType == .layout ? "books.vertical" : "square.grid.3x3")
            Text(viewModel.levelType.rawValue)
        }
        .tag(viewModel.levelType)
        
    }
}

#Preview("Layout") {
    let testLayouts = [
        Level(id: UUID(), number: 1, attemptedLetters: nil),
        Level(id: UUID(), number: 2, attemptedLetters: nil)
    ]
    
    let testPlayableLevels = [
        Level(id: UUID(), number: 1, attemptedLetters: nil),
        Level(id: UUID(), number: 2, attemptedLetters: nil),
        Level(id: UUID(), number: 3, attemptedLetters: nil),
        Level(id: UUID(), number: 5, attemptedLetters: nil)
    ]
    
    withDependencies {
        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
    } operation: {
        let viewModel = LevelListViewModel(navigationViewModel: NavigationViewModel(), levelType: .layout)
        
        return LevelListView(viewModel)
    }
}

#Preview("Playable") {
    let testLayouts = [
        Level(id: UUID(), number: 1, attemptedLetters: nil),
        Level(id: UUID(), number: 2, attemptedLetters: nil)
    ]
    
    let testPlayableLevels = [
        Level(id: UUID(), number: 1, attemptedLetters: nil),
        Level(id: UUID(), number: 2, attemptedLetters: nil),
        Level(id: UUID(), number: 3, attemptedLetters: nil),
        Level(id: UUID(), number: 5, attemptedLetters: nil)
    ]
    
    withDependencies {
        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
    } operation: {
        let viewModel = LevelListViewModel(navigationViewModel: NavigationViewModel(), levelType: .playable)
        
        return LevelListView(viewModel)
    }
}


