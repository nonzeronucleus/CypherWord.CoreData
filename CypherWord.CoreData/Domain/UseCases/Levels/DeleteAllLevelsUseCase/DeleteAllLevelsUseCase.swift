import Foundation
import Dependencies

protocol DeleteAllLevelsUseCaseProtocol {
    func execute(levelType: LevelType) async throws -> [LevelDefinition]
}


class DeleteAllLevelsUseCase: LevelsUseCase, DeleteAllLevelsUseCaseProtocol {
    func execute(levelType: LevelType) async throws -> [LevelDefinition] {
//        try await levelRepository.deleteAll (levelType: levelType)
        try levelRepository.deleteAllLevels(levelType: levelType)
        levelRepository.commit()
        
        if levelType == .playable {
            try levelRepository.deleteAllPacks()
        }

        return try await levelRepository.fetchLayouts()
    }
}
