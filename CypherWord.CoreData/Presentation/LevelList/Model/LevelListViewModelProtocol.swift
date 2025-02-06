import Foundation

class LevelListViewModelProtocol: ObservableObject {
    @Published var levels: [Level] = []
    @Published var layouts: [Level] = []
    @Published var error:String?
    
    @Published private(set) var selectedLevel: Level?
    
    @Published var selectedLevelID: UUID? {
        didSet {
            updateSelectedLevel()
        }
    }
    
    @Published var showDetail: Bool = false

    func updateSelectedLevel() {
        selectedLevel = layouts.first(where: { $0.id == selectedLevelID })
        showDetail = selectedLevel != nil
    }
    
    func deleteAll(levelType: Level.LevelType) {
    }
    
    func addLayout() {
    }
}
