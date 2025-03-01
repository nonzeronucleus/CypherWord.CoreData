import Foundation
import Dependencies

class DeleteAllLevelsUseCase: LevelsUseCase, DeleteAllLevelsUseCaseProtocol {
    func execute(levelType: LevelType) async throws -> [LevelDefinition] {
        try await levelRepository.deleteAll (levelType: levelType)
        return try await levelRepository.fetchLevels(levelType: levelType)
    }
}
