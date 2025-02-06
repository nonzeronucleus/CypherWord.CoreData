import Foundation

class PreviewLevelListViewModel: LevelListViewModel {
    
    override func fetchLevels() {
        levels = [Level(id: UUID(), number: 1), Level(id: UUID(), number: 2)]
    }
    
    override func fetchLayouts() {
        layouts = [Level(id: UUID(), number: 1), Level(id: UUID(), number: 2)]
    }
}
