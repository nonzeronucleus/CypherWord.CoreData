import SwiftUI

struct LevelListView : View {
    @EnvironmentObject var viewModel: LevelListViewModel
    
//    @ObservedObject var viewModel : LevelListViewModel
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var showThoughtsView = false
    var levelType: Level.LevelType
    
    init(levelType: Level.LevelType) {
        self.levelType = levelType
    }
    
    var primaryColor: Color {
        levelType == .layout ? .green : .blue
    }
    
    var secondaryColor: Color {
        levelType == .layout ? .teal : .cyan
    }
    
    var body: some View {
        VStack {
            Text(levelType == .layout ? "Layout" :"Level")
                .frame(maxWidth: .infinity)
                .padding(CGFloat(integerLiteral: 20))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .background(primaryColor)
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    let levels = levelType == .layout ? viewModel.layouts : viewModel.levels
                    ForEach(levels) { level in
                        CartoonButton(levelNumber:level.number, gradient:Gradient(colors: [primaryColor, secondaryColor])) {
                            viewModel.selectedLevelID = level.id
                        }
                    }
                }
            }

            if levelType == .layout {
                Button("Add") {
                    viewModel.addLayout()
                }
            }
            Button("Delete all") {
                viewModel.deleteAll(levelType: levelType)
            }
            Button("Import") {
//                viewModel.importLayouts()
            }
            Spacer()
        }
    }
}

#Preview {
    let fetchLayoutsUseCase = FetchLevelsUseCaseMock(levels:
        [Level(id: UUID(), number: 1),
        Level(id: UUID(), number: 2)]
    )
    let fetchPlayableLevelsUseCase = FetchLevelsUseCaseMock(levels:
        [Level(id: UUID(), number: 1),
        Level(id: UUID(), number: 2),
         Level(id: UUID(), number: 3)]
    )
    let addLayoutUseCase: AddLayoutUseCaseProtocol = AddLayoutUseCaseMock()
    let deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol = DeleteAllLevelsUseCaseMock()
    
    
    let viewModel = LevelListViewModel()
//        fetchLayoutsUseCase: fetchLayoutsUseCase,
//                                       fetchPlayableLevelsUseCase: fetchPlayableLevelsUseCase,
//                                       addLayoutUseCase: addLayoutUseCase,
//                                       deleteAllLevelstUseCase: deleteAllLevelsUseCase)

    LevelListView(levelType: .layout)
        .environmentObject(viewModel)
}

