import Foundation
import Dependencies

final class ContentViewModel: ObservableObject {
    @Published var isInitialized = true
    @Published var error: String?
    @Dependency(\.importLevelsUseCase) private var importLeveslUseCase: ImportLevelsUseCaseProtocol

    init() {
    }
    
    func start2() {
        isInitialized = true
    }
    

    private func saveLevels(levelType: Level.LevelType, levels: [Level]) {
        
    }
}
