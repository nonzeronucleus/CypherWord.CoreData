import SwiftUI
import Dependencies

struct LevelListView : View {
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var showThoughtsView = false
    @ObservedObject var viewModel: LevelListViewModel
    init(_ viewModel: LevelListViewModel) {
        self.viewModel = viewModel
    }
    
    func primaryColor(level:LevelDefinition? = nil) -> Color {
        if viewModel.levelType == .layout {
            return .orange
        }
        else {
            if let level = level {
                if level.numCorrectLetters == 26 {
                    return .green
                }
            }
        }
        return .blue
    }
    
    
    func secondaryColor(level:LevelDefinition? = nil) -> Color {
        if viewModel.levelType == .layout {
            return .red
        }
        else {
            if let level = level {
                if level.numCorrectLetters == 26 {
                    return .mint
                }
            }
        }
        return .cyan
    }
    
    var body: some View {
        VStack {
            Text(viewModel.levelType.rawValue)
                .frame(maxWidth: .infinity)
                .padding(CGFloat(integerLiteral: 20))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .background(primaryColor())
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    let levels = viewModel.levels
                    ForEach(levels) { level in
                        if let number = level.number {
                            CartoonButton(levelNumber:number, gradient:Gradient(colors: [primaryColor(level: level), secondaryColor(level: level)])) {
                                viewModel.onSelectLevel(level: level)
                            }
                        }
                        else {
                            fatalError("No Number for Level \(level.id)")
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
        LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 2, attemptedLetters: nil)
    ]
    
    let testPlayableLevels = [
        LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 2, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 3, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 5, attemptedLetters: nil)
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
        LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 2, attemptedLetters: nil)
    ]
    
    let testPlayableLevels = [
        LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 2, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 3, attemptedLetters: nil),
        LevelDefinition(id: UUID(), number: 5, attemptedLetters: nil)
    ]
    
    withDependencies {
        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
    } operation: {
        let viewModel = LevelListViewModel(navigationViewModel: NavigationViewModel(), levelType: .playable)
        
        return LevelListView(viewModel)
    }
}


