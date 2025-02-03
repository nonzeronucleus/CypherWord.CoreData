import SwiftUI


enum Tab: String, CaseIterable, Identifiable {
    case level
    case layout

    var id: Self { self }
}

struct TabsView: View {
    @ObservedObject var model : LevelListViewModel
    @State var selection: Tab = .level

    init(model : LevelListViewModel) {
        self.model = model
    }
    
    var body: some View {
        TabView(selection: $selection) {
            LevelListView(model: model, levelType: .playable) //isLevel: true)
                .tabItem {
                    Image(systemName: "books.vertical")
                     Text("Levels")
                 }
                .tag(Tab.level)
            LevelListView(model: model, levelType: .layout) //isLevel: false)
                .tabItem {
                    Image(systemName: "person")
                     Text("Layout")
                 }
                .tag(Tab.layout)
        }
    }
}
