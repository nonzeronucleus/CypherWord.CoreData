import SwiftUI
import Dependencies

struct NavigationView : View {
    @EnvironmentObject var applicationViewModel: ApplicationViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject private var viewModel: NavigationViewModel
    @State var selection: LevelType = .playable
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack {
                if let error = viewModel.error {
                    Text("Error: \(error)")
                }
                
                VStack {
                    if settingsViewModel.settings.editMode {
                        TabView(selection: $selection) {
                            LevelListView(viewModel.createLevelListViewModel(levelType: .playable))
                            LevelListView(viewModel.createLevelListViewModel( levelType: .layout))
                        }
                    }
                    else {
                        LevelListView(viewModel.createLevelListViewModel(levelType: .playable))
                    }
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
                            }                        case .settings:
                            SettingsView()
                    }
                }
            }
        }
    }
}

#Preview {
    @Dependency(\.uuid) var uuid

    let testLayouts = [
        LevelDefinition(id: uuid(), number: 1, packId: nil),
        LevelDefinition(id: uuid(), number: 2, packId: nil),
    ]
    
    let testPlayableLevels = [
        LevelDefinition(id: uuid(), number: 1, packId: uuid()),
        LevelDefinition(id: uuid(), number: 2, packId: uuid()),
    ]
    
    withDependencies {
        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
    } operation: {
        let settingsViewModel =  SettingsViewModel(parentId:nil)
        let navigationView = NavigationViewModel(settingsViewModel:settingsViewModel)
//        let viewModel = LevelListViewModel()
        return NavigationView(/*viewModel*/)
            .environmentObject(navigationView)
            .environmentObject(settingsViewModel)
    }
}




