import Foundation
import Combine


class OldLevelListViewModel: LevelListViewModelProtocol {

    var levelService = LevelDataService.shared
    private var cancellables = Set<AnyCancellable>()

    
    override init() {
        super.init()
        levels = fetchLevels()
        layouts = fetchLayouts()
    }
    
    func fetchLevels() -> [Level] {
        let levels = levelService.levels
        levelService.$levels
            .sink { newLevels in
                self.levels = newLevels
                self.updateSelectedLevel()
            }
            .store(in: &cancellables)
        return levels
    }
        
    func fetchLayouts() -> [Level] {
        let layouts = levelService.layouts
        levelService.$layouts
            .sink { newLevels in
                self.layouts = newLevels
                self.updateSelectedLevel()
            }
            .store(in: &cancellables)
        return layouts
    }
    
    func addLevel(levelType: Level.LevelType) {
        if levelType == .layout {
            levelService.addLayout()
        }
        else {
            levelService.addPlayableLevel()
        }
    }
    
    override func deleteAll(levelType: Level.LevelType) {
        levelService.deleteAll(levelType: levelType)
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
    
//    private func updateSelectedLevel() {
//        selectedLevel = layouts.first(where: { $0.id == selectedLevelID })
//        showDetail = selectedLevel != nil
//    }
}
