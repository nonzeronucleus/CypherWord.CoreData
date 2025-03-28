import SwiftUI

struct ContentView: View {
    @StateObject var model = ContentViewModel()
    @State var selection:LevelType = .playable

    init () {
    }

    var body: some View {
        Group {
            if let error = model.error {
                Text("Content Error:" + error)
            }
            if model.isInitialized {
                LazyView(NavigationView())
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
