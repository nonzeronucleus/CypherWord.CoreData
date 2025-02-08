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
    TabsView()
        .environmentObject(viewModel)
}

