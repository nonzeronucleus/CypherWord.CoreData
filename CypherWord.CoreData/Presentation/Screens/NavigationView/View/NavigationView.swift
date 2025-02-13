import SwiftUI
import Dependencies

struct NavigationView : View {
//    @ObservedObject var viewModel: LevelListViewModel
    @StateObject private var viewModel = NavigationViewModel()
    
//    @ObservedObject var navigationViwModel: NavigationViewModel = NavigationViewModel()

    init(/*_  viewModel: LevelListViewModel*/) {
//        self.viewModel = viewModel
//        var navigationViewModel = NavigationViewModel()
        
//        self.viewModel = .init(navigationViewModel: navigationViewModel)
//        self.navigationViewModel = navigationViewModel
//        self.viewModel.navigationViewModel = self.navigationViewModel

//        self.viewModel.reload()
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack {
//                if let error = viewModel.error {
//                    Text("Error: \(error)")
//                }
                TabsView()
                    .navigationDestination(for: Level.LevelType.self) { destination in
                        switch destination {
                            case .layout:
                            LevelEditView(viewModel.createLayoutViewModel())
                                    .navigationBarBackButtonHidden(true)
                            case .playable:
//                                Text("Not yet implemented")
                            GameView(viewModel.createGameViewModel())
                                    .navigationBarBackButtonHidden(true)
                        }
                    }
                    .environmentObject(LevelListViewModel(navigationViewModel: viewModel))
            }
        }
    }
}

//#Preview {
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
////        let viewModel = LevelListViewModel()
//        return NavigationView(/*viewModel*/)
//    }
//}


//
//                                           //                        if let selectedLevel = viewModel.selectedLayout {
//                                           //                            LevelEditView(.init(level: selectedLevel))
//                                           //                        }
//                                           //                        else if let selectedLevel = viewModel.selectedPlayableLevel {
//                                           //                            GameView(.init(level: selectedLevel))
//                                           //                        }
//                                                                   switch destination {
//                                                                   case .edit:
//                                           //                            LevelEditView(.init(level: selectedLevel))
//                                                                           LevelEditView(viewModel.createLayoutViewModel())
//
//                                           //                            DetailView(viewModel: DetailViewModel(navigationViewModel: navigationViewModel))
//                                                                   case .game:
//                                                                           GameView(viewModel.createGameViewModel())
//                                           //                            SettingsView(viewModel: SettingsViewModel(navigationViewModel: navigationViewModel))
//                                                                   }
//                                                               }
//                                                               .environmentObject(viewModel)
//                                           //                    .navigationDestination(isPresented: $viewModel.showDetail) {
//                                           //                        if let selectedLevel = viewModel.selectedLayout {
//                                           //                            LevelEditView(.init(level: selectedLevel))
//                                           //                        }
//                                           //                        else if viewModel.selectedPlayableLevel != nil {
//                                           //                            GameView(viewModel.createGameViewModel())
//                                           //                        }
//                                           //                    }
//                                           //                    .environmentObject(viewModel)
