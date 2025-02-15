import SwiftUI
import Dependencies

struct LevelListView : View {
//    @EnvironmentObject var viewModel: LevelListViewModel
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var showThoughtsView = false
    @ObservedObject var viewModel: LevelListViewModel
//    var levelType: Level.LevelType
    
//    init(levelType: Level.LevelType) {
    init(_ viewModel: LevelListViewModel) {
//        self.levelType = levelType
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
            Text(viewModel.levelType == .layout ? "Layout" :"Level")
                .frame(maxWidth: .infinity)
                .padding(CGFloat(integerLiteral: 20))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .background(primaryColor)
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
//                    let levels = levelType == .layout ? viewModel.layouts : viewModel.levels
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
            Button("Import") {
//                viewModel.importLayouts()
            }
            Spacer()
        }
    }
}

//#Preview("Layout") {
//    let testLayouts = [
//        Level(id: UUID(), number: 1),
//        Level(id: UUID(), number: 2)
//    ]
//    
//    let testPlayableLevels = [
//        Level(id: UUID(), number: 1),
//        Level(id: UUID(), number: 2),
//        Level(id: UUID(), number: 3),
//        Level(id: UUID(), number: 4)
//    ]
//    
//    withDependencies {
//        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
//    } operation: {
//        let viewModel = LevelListViewModel()
//        
//        return LevelListView(levelType: .layout)
//            .environmentObject(viewModel)
//    }
//}

//#Preview("Playable") {
//    let testLayouts = [
//        Level(id: UUID(), number: 1),
//        Level(id: UUID(), number: 2)
//    ]
//    
//    let testPlayableLevels = [
//        Level(id: UUID(), number: 1),
//        Level(id: UUID(), number: 2),
//        Level(id: UUID(), number: 3),
//        Level(id: UUID(), number: 4)
//    ]
//    
//    withDependencies {
//        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
//    } operation: {
//        let viewModel = LevelListViewModel()
//        
//        return LevelListView(levelType: .playable)
//            .environmentObject(viewModel)
//    }
//}



