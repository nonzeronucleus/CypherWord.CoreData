import SwiftUI

struct LevelListRootView : View {
    @ObservedObject var viewModel: LevelListViewModelProtocol
    
    init(_ viewModel: LevelListViewModelProtocol) {
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

//#Preview {
//    let layoutRepository = LevelStorageCoreData()
//    let fetchLayoutsUseCase = FetchLayoutssUseCase(repository: layoutRepository)
//    let fetchPlayableLevelsUseCase = FetchPlayableLevelsUseCase(repository: layoutRepository)
//    let addLayoutUseCase = AddLayoutUseCase(repository: layoutRepository)
//    let viewModel:LevelListViewModel = PreviewLevelListViewModel(
//        fetchLayoutsUseCase: fetchLayoutsUseCase,
//        fetchPlayableLevelsUseCase:fetchPlayableLevelsUseCase,
//        addLayoutUseCase: addLayoutUseCase
//    )
//    
//    LevelListRootView(viewModel)
//}
