import SwiftUI

struct LevelListView : View {
    @ObservedObject var model : LevelListViewModel
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var showThoughtsView = false
    
    init(model : LevelListViewModel) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            Text("Level")
                .frame(maxWidth: .infinity)
                .padding(CGFloat(integerLiteral: 20))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .background(Color.blue)
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(model.levels) { level in
                        CartoonButton(levelNumber:level.number) {
                            model.selectedLevelID = level.id
                        }
                    }
                }
            }
            
            Button("Add") {
                model.addLevel()
            }
            Button("Delete all") {
                model.deleteAll()
            }
            Spacer()
        }
    }
}

