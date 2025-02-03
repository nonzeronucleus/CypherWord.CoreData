import SwiftUI

struct LevelListView : View {
    @ObservedObject var model : LevelListViewModel
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var showThoughtsView = false
    var levelType: Level.LevelType
    
    init(model : LevelListViewModel, levelType: Level.LevelType) {
        self.model = model
        self.levelType = levelType
    }
    
    var primaryColor: Color {
        levelType == .layout ? .green : .blue
    }
    
    var secondaryColor: Color {
        levelType == .layout ? .teal : .cyan
    }
    
    var body: some View {
        VStack {
            Text(levelType == .layout ? "Layout" :"Level")
                .frame(maxWidth: .infinity)
                .padding(CGFloat(integerLiteral: 20))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .background(primaryColor)
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    let levels = levelType == .layout ? model.layouts : model.levels
                    ForEach(levels) { level in
                        CartoonButton(levelNumber:level.number, gradient:Gradient(colors: [primaryColor, secondaryColor])) {
                            model.selectedLevelID = level.id
                        }
                    }
                }
            }
            
            Button("Add") {
                model.addLevel(levelType: levelType)
            }
            Button("Delete all") {
                model.deleteAll(levelType: levelType)
            }
            Spacer()
        }
    }
}

