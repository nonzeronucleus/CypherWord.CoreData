import Foundation
import Combine

class LevelListViewModel: ObservableObject {
    @Published private(set) var levels: [Level]
    @Published var selectedLevelID:UUID? = nil {
        didSet {
            showDetail = selectedLevelID != nil
        }
    }
    var selectedLevel: Level? {
        guard let id = selectedLevelID else { return nil }
        return levels.first(where: { $0.id == id })
    }
    @Published var showDetail: Bool = false
    var levelService = LevelDataService()
    private var cancellables = Set<AnyCancellable>()

    
    init() {
        levels = levelService.levels
        levelService.$levels
            .sink { newLevels in
                self.levels = newLevels
            }
            .store(in: &cancellables)
    }
    
    func addLevel() {
        levelService.addPlayableLevel()
    }
    
    func deleteAll() {
        levelService.deleteAll()
    }
    
    func onCellClick(uuid:UUID) {
        print("\(uuid)")
//        if completed {
//            return
//        }
//        
//        checking = false
        
//        let cell = crossword.findElement(byID: uuid)
//        
//        if let cell = cell {
//            if let letter = cell.letter {
//                if let number = letterValues?[letter] {
//                    selectedNumber = number
//                }
//            }
//        }
    }
}
