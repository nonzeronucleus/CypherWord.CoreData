import SwiftUI

struct ContentView: View {
    @State var selection:Tab = .level
    let viewModel:LevelListViewModelProtocol

    init () {
        let layoutRepository = LevelStorageCoreData()
//        let layoutRepository = LevelRepositoryFile()
        let fetchLayoutsUseCase = FetchLayoutssUseCase(repository: layoutRepository)
        let fetchPlayableLevelsUseCase = FetchPlayableLevelsUseCase(repository: layoutRepository)
        let addLayoutUseCase = AddLayoutUseCase(repository: layoutRepository, fetchLayoutsUseCase: fetchLayoutsUseCase)
        let deleteAllLevelsUseCase = DeleteAllLevelsUseCase(repository: layoutRepository, fetchLayoutsUseCase: fetchLayoutsUseCase)
        
        viewModel = LevelListViewModel(
            fetchLayoutsUseCase: fetchLayoutsUseCase,
            fetchPlayableLevelsUseCase:fetchPlayableLevelsUseCase,
            addLayoutUseCase: addLayoutUseCase,
            deleteAllLevelstUseCase: deleteAllLevelsUseCase
        )
    }

    var body: some View {
        LevelListRootView(viewModel)
    }
}

struct FirstView: View {
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    ContentView()
}
