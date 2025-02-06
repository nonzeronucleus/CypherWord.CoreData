import Foundation

class PreviewLevelListViewModel: LevelListViewModelProtocol {
    
    override init() {
        super.init()
        levels = [Level(id: UUID(), number: 1), Level(id: UUID(), number: 2)]
        layouts = [Level(id: UUID(), number: 1), Level(id: UUID(), number: 2)]
    }
    
}
