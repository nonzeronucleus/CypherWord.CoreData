import Foundation
import Dependencies

protocol AddPlayableLevelUseCaseProtocol {
    func execute(layout: LevelDefinition) async throws
}


class AddPlayableLevelUseCase : AddPlayableLevelUseCaseProtocol {
    var levelRepository: PlayableLevelRepositoryProtocol
    
    init(levelRepository: PlayableLevelRepositoryProtocol) {
        self.levelRepository = levelRepository
    }

    func execute(layout: LevelDefinition) async throws {
        @Dependency(\.uuid) var uuid
        let manifest = try await levelRepository.getManifest()
        let cureentPackNum = levelRepository.getCurrentPackNum()
        guard let pack = manifest.getLevelFileDefinition(forNumber: cureentPackNum) else {
            fatalError("Could not find pack for \(cureentPackNum)")
        }
        
        let nextNum = try levelRepository.fetchHighestLevelNumber(levelType: .playable) + 1
        
        let level = LevelDefinition(
            id: uuid(),
            number: nextNum,
            packId: pack.id,
            gridText: layout.gridText,
            letterMap: layout.letterMap
        )
        
        try await levelRepository.prepareLevelMO(from: level)
    
        levelRepository.commit()
    }
}
