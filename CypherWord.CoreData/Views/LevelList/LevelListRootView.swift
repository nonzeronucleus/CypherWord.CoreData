import SwiftUI

struct LevelListRootView : View {
    @ObservedObject var viewModel: LevelListViewModel
    
    init(_ viewModel: LevelListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            TabsView()
                .navigationDestination(isPresented: $viewModel.showDetail) {
                    if let selectedLevel = viewModel.selectedLevel {
                        LevelEditView(.init(level: selectedLevel))
                    }
                }
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    let viewModel:LevelListViewModel = PreviewLevelListViewModel()
    
    LevelListRootView(viewModel)
//        .environmentObject(viewModel)
}
