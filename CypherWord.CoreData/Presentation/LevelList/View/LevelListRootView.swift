import SwiftUI

struct LevelListRootView : View {
    @ObservedObject var viewModel: LevelListViewModelProtocol
    
    init(_ viewModel: LevelListViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let error = viewModel.error {
                    Text("Error: \(error)")
                }
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
}

#Preview {
    let viewModel:LevelListViewModelProtocol = PreviewLevelListViewModel()

    LevelListRootView(viewModel)
}
