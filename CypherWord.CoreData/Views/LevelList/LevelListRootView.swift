import SwiftUI

struct LevelListRootView : View {
    @ObservedObject var model = LevelListViewModel()
    
    var body: some View {
        NavigationStack {
            TabsView(model: model)
                .navigationDestination(isPresented: $model.showDetail) {
                    if let selectedLevel = model.selectedLevel {
                        LevelEditView(level: selectedLevel)
                    }
//                    if let crossword = model.crossword {
//                        CrosswordView(grid: crossword, viewMode: .actualValue, performAction: { id in model.onCellClick(uuid: id) })
//                    }
                }
        }
    }
}
