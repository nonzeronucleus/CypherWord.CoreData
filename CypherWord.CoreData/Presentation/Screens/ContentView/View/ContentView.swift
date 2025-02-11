import SwiftUI

struct ContentView: View {
    @StateObject var model = ContentViewModel()
    @State var selection:Tab = .level
//    let listViewModel:LevelListViewModel

    init () {
//        listViewModel = LevelListViewModel(navigationViewModel: <#T##NavigationViewModel#>)
    }

    var body: some View {
        Group {
            if model.isInitialized {
                NavigationView(/*listViewModel*/)
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
