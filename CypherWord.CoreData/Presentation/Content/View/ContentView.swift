import SwiftUI

struct ContentView: View {
    @State var selection:Tab = .level
    let viewModel:LevelListViewModel

    init () {
//        let fetchLayoutsUseCase = FetchLayoutsUseCase()
//        let fetchPlayableLevelsUseCase = FetchPlayableLevelsUseCase()
//        let addLayoutUseCase = AddLayoutUseCase(fetchLayoutsUseCase: fetchLayoutsUseCase)
//        let deleteAllLevelsUseCase = DeleteAllLevelsUseCase(fetchLayoutsUseCase: fetchLayoutsUseCase)
        
        viewModel = LevelListViewModel(
//            fetchLayoutsUseCase: fetchLayoutsUseCase,
//            fetchPlayableLevelsUseCase:fetchPlayableLevelsUseCase,
//            addLayoutUseCase: addLayoutUseCase,
//            deleteAllLevelstUseCase: deleteAllLevelsUseCase
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
