import Foundation
import Dependencies

protocol AddPlayableLevelUseCaseProtocol {
    func execute(packDefinition: PackDefinition, layout: LevelDefinition) async throws
}


class AddPlayableLevelUseCase : AddPlayableLevelUseCaseProtocol {
    var levelRepository: PlayableLevelRepositoryProtocol
    
    init(levelRepository: PlayableLevelRepositoryProtocol) {
        self.levelRepository = levelRepository
    }

    func execute(packDefinition: PackDefinition, layout: LevelDefinition) async throws {
        @Dependency(\.uuid) var uuid
        
        let nextNum = try levelRepository.fetchHighestLevelNumber(levelType: .playable, packId: packDefinition.id) + 1
        
        let level = LevelDefinition(
            id: uuid(),
            number: nextNum,
            packId: packDefinition.id,
            gridText: layout.gridText,
            letterMap: layout.letterMap
        )
        
        try await levelRepository.prepareLevelMO(from: level)
        
        if await !levelRepository.packExists(packDefinition: packDefinition) {
            try await levelRepository.writePackToManifest(packDefinition: packDefinition)
        }
    
        levelRepository.commit()
    }
}


//        let manifest = try await levelRepository.getManifest()
//        let currentPackNum = levelRepository.getCurrentPackNum()
//        guard let pack = manifest.getLevelFileDefinition(forNumber: currentPackNum) else {
//            fatalError("Could not find pack for \(currentPackNum)")
//        }
