import SwiftUI

struct LevelListRootView : View {
    @ObservedObject var model = LevelListViewModel()
    
    var body: some View {
        NavigationStack {
            TabsView(model: model)
                .navigationDestination(isPresented: $model.showDetail) {
                    if let selectedLevel = model.selectedLevel {
                        let transformer = CrosswordTransformer()
                        
                        if let crossword = transformer.reverseTransformedValue(selectedLevel.gridText) as? Crossword {
                            CrosswordView(grid: crossword, viewMode: .actualValue, performAction: { id in model.onCellClick(uuid: id) })
                        }
                    }
                }
        }
    }
}
