import SwiftUI

struct LevelListView : View {
    @ObservedObject var model = LevelListViewModel()
    
    var body: some View {
        VStack {
            List(model.levels) { level in
                Text(level.name)
            }
            
            Button("Add") {
                model.addLevel()
            }
            Button("Delete all") {
                model.deleteAll()
            }
        }
    }
}
