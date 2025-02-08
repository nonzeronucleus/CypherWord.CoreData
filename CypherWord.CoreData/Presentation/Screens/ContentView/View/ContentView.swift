import SwiftUI

struct ContentView: View {
    @StateObject var model = ContentViewModel()
    @State var selection:Tab = .level
    let listViewModel:LevelListViewModel

    init () {
        listViewModel = LevelListViewModel()
    }

    var body: some View {
        Group {
            if model.isInitialized {
                LevelListRootView(listViewModel)
            } else {
                StartupLoadingView()
            }
        }
        .onAppear {
            model.start()
        }
        //
    }
}

struct StartupLoadingView: View {
    
    var body: some View {
        Text("Loading")
    }
}

#Preview {
    ContentView()
}
