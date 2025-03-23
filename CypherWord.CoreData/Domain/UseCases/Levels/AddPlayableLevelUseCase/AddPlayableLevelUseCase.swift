import Foundation
import Dependencies

protocol AddPlayableLevelUseCaseProtocol {
    func execute(layout: LevelDefinition, packNum: Int) async throws
}


class AddPlayableLevelUseCase : LevelsUseCase, AddPlayableLevelUseCaseProtocol {
    func execute(layout: LevelDefinition, packNum: Int) async throws {
        @Dependency(\.uuid) var uuid
        let manifest = try await levelRepository.getManifest()
        guard let pack = manifest.getLevelFileDefinition(forNumber: packNum) else {
            fatalError("Could not find pack for \(packNum)")
        }
        
        let nextNum = try levelRepository.fetchHighestNumber(levelType: .playable) + 1
        
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
