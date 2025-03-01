import Foundation
import Dependencies

class AddLayoutUseCase: LevelsUseCase, AddLayoutUseCaseProtocol {
    func execute() async throws -> [LevelDefinition] {
        try await levelRepository.addLayout()
        return try await levelRepository.fetchLevels(levelType: .layout)
    }
}
