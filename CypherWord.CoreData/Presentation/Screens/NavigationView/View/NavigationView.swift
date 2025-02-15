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
                    LevelListView(LevelListViewModel(navigationViewModel: viewModel, levelType: .playable))
                    
                    LevelListView(LevelListViewModel(navigationViewModel: viewModel, levelType: .layout))
                }
                .navigationDestination(for: LevelType.self) { destination in
                    switch destination {
                        case .layout:
                            LevelEditView(viewModel.createLayoutViewModel())
                                .navigationBarBackButtonHidden(true)
                        case .playable:
                            GameView(viewModel.createGameViewModel())
                                .navigationBarBackButtonHidden(true)

                    }
                }
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
