import SwiftUI
import Dependencies




struct NavigationView : View {
    @StateObject private var viewModel = NavigationViewModel()
    @State var selection: LevelType = .playable
   
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack {
                if let error = viewModel.error {
                    Text("Error: \(error)")
                }
                TabView(selection: $selection) {
                    LevelListView(viewModel.createLevelListViewModel(levelType: .playable))
                    
                    LevelListView(viewModel.createLevelListViewModel( levelType: .layout))
                }
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                        case .detail:
                            switch viewModel.level?.levelType {
                                case .layout:
                                    LevelEditView(viewModel.createLayoutViewModel())
                                        .navigationBarBackButtonHidden(true)
                                case .playable:
                                    GameView(viewModel.createGameViewModel())
                                        .navigationBarBackButtonHidden(true)
                                case .none:
                                    Text("Error loading level")
                            }
                        case .settings:
                            SettingsView(viewModel.createSettingsViewModel())
                    }
                }
            }
        }
    }
}

#Preview {
    let testLayouts = [
        LevelDefinition(id: UUID(), number: 1),
        LevelDefinition(id: UUID(), number: 2),
    ]
    
    let testPlayableLevels = [
        LevelDefinition(id: UUID(), number: 1),
        LevelDefinition(id: UUID(), number: 2),
    ]
    
    withDependencies {
        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
    } operation: {
//        let viewModel = LevelListViewModel()
        return NavigationView(/*viewModel*/)
    }
}


