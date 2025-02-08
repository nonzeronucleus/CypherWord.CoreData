import SwiftUI

struct ContentView: View {
    @State var selection:Tab = .level
    let viewModel:LevelListViewModel

    init () {
        viewModel = LevelListViewModel()
    }

    var body: some View {
        LevelListRootView(viewModel)
    }
}

struct FirstView: View {
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    ContentView()
}
