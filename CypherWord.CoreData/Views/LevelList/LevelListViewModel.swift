import Foundation
import Combine

class LevelListViewModel: ObservableObject {
    @Published private(set) var levels: [Level]
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
        levelService.addLevel()
    }
    
    func deleteAll() {
        levelService.deleteAll()
    }
}
