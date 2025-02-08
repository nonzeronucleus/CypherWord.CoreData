import SwiftUI
import Dependencies


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
    let testLayouts = [
        Level(id: UUID(), number: 1),
        Level(id: UUID(), number: 2)
    ]
    
    let testPlayableLevels = [
        Level(id: UUID(), number: 1),
        Level(id: UUID(), number: 2),
        Level(id: UUID(), number: 3),
        Level(id: UUID(), number: 4)
    ]
    
    withDependencies {
        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
    } operation: {
        let viewModel = LevelListViewModel()

        return TabsView()
            .environmentObject(viewModel)
    }
}

