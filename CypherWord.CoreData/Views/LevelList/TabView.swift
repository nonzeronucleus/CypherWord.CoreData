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


