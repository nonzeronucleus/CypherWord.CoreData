import SwiftUI
import Dependencies


enum Tab: String, CaseIterable, Identifiable {
    case level
    case layout

    var id: Self { self }
}
//
//struct TabsView: View {
//    @State var selection: Tab = .level
//
//    var body: some View {
//        TabView(selection: $selection) {
//            LevelListView(levelType: .playable)
//                .tabItem {
//                    Image(systemName: "books.vertical")
//                     Text("Levels")
//                 }
//                .tag(Tab.level)
//            LevelListView(levelType: .layout)
//                .tabItem {
//                    Image(systemName: "person")
//                     Text("Layout")
//                 }
//                .tag(Tab.layout)
//        }
//    }
//}



struct TabsView<Content: View>: View {
    @State var selection: Tab = .level
    
    let tab1: () -> Content
    let tab2: () -> Content

    init(tab1: @autoclosure @escaping () -> Content,
         tab2: @autoclosure @escaping () -> Content) {
        self.tab1 = tab1
        self.tab2 = tab2
    }
    
//    var body: Content {
    var body: some View {
        TabView(selection: $selection) {
            tab1()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Levels")
                }
                .tag(Tab.level)
            tab2()
                .tabItem {
                    Image(systemName: "person")
                    Text("Layout")
                }
                .tag(Tab.layout)
        }
    }
    
}
