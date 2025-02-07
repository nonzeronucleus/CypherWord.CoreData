import SwiftUI

struct LevelListRootView : View {
    @ObservedObject var viewModel: LevelListViewModel
    
    init(_ viewModel: LevelListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let error = viewModel.error {
                    Text("Error: \(error)")
                }
                TabsView()
                    .navigationDestination(isPresented: $viewModel.showDetail) {
                        if let selectedLevel = viewModel.selectedLevel {
                            LevelEditView(.init(level: selectedLevel))
                        }
                    }
                    .environmentObject(viewModel)
            }
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
    
    
    let viewModel = LevelListViewModel(fetchLayoutsUseCase: fetchLayoutsUseCase,
                                       fetchPlayableLevelsUseCase: fetchPlayableLevelsUseCase,
                                       addLayoutUseCase: addLayoutUseCase,
                                       deleteAllLevelstUseCase: deleteAllLevelsUseCase)
    
    LevelListRootView(viewModel)
}
