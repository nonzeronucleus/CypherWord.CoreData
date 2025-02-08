import SwiftUI


enum Tab: String, CaseIterable, Identifiable {
    case level
    case layout

    var id: Self { self }
}

struct TabsView: View {
    @State var selection: Tab = .level

    var body: some View {
        TabView(selection: $selection) {
            LevelListView(levelType: .playable)
                .tabItem {
                    Image(systemName: "books.vertical")
                     Text("Levels")
                 }
                .tag(Tab.level)
            LevelListView(levelType: .layout)
                .tabItem {
                    Image(systemName: "person")
                     Text("Layout")
                 }
                .tag(Tab.layout)
        }
    }
}

#Preview {
    //    let fetchLayoutsUseCase = FetchLevelsUseCaseMock(levels:
    //        [Level(id: UUID(), number: 1),
    //        Level(id: UUID(), number: 2)]
    //    )
    //    let fetchPlayableLevelsUseCase = FetchLevelsUseCaseMock(levels:
    //        [Level(id: UUID(), number: 1),
    //        Level(id: UUID(), number: 2),
    //         Level(id: UUID(), number: 3)]
    //    )
    //    let addLayoutUseCase: AddLayoutUseCaseProtocol = AddLayoutUseCaseMock()
    //    let deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol = DeleteAllLevelsUseCaseMock()
    
//    let testData1 = [
//        Level(id: UUID(), number: 1),
//        Level(id: UUID(), number: 2)
//    ]
//    
//    
    let viewModel = LevelListViewModel()
//    
//    TabsView()
//        .environmentObject(viewModel)
//        .withDependencies {
//            $0.levelRepository = FakeLevelRepository(testLevels: testData1)
//        }
    
    TabsView()
        .environmentObject(viewModel)
}

