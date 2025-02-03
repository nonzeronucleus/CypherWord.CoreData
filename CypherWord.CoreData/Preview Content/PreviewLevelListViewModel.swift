import Foundation

class PreviewLevelListViewModel: LevelListViewModel {
    
    override func fetchLevels() -> [Level] {
        return [Level(id: UUID(), number: 1), Level(id: UUID(), number: 2)]
    }
    
    override func fetchLayouts() -> [Level] {
        return [Level(id: UUID(), number: 1), Level(id: UUID(), number: 2)]
    }
}
