import Foundation
import Dependencies

class AddPlayableLevelUseCase : LevelsUseCase, AddPlayableLevelUseCaseProtocol {
    func execute(level: LevelDefinition) async throws {
        try await levelRepository.addPlayableLevel(level: level)
    }
}
