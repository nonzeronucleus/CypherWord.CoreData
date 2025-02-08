import SwiftUI
import Dependencies

struct LevelListRootView : View {
    @ObservedObject var viewModel: LevelListViewModel

    init(_ viewModel: LevelListViewModel) {
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
        return LevelListRootView(viewModel)
    }
}
