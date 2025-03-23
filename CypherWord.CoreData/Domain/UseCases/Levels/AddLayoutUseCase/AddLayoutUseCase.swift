import Foundation
import Dependencies

protocol AddLayoutUseCaseProtocol {
    func execute() async throws -> [LevelDefinition]
}


class AddLayoutUseCase: LevelsUseCase, AddLayoutUseCaseProtocol {
    func execute() async throws -> [LevelDefinition] {
        @Dependency(\.uuid) var uuid
        
        let nextNum = try levelRepository.fetchHighestNumber(levelType: .layout) + 1

        let layout = LevelDefinition(
            id: uuid(),
            number: nextNum,
            packId: nil,
            attemptedLetters: ""
        )
        
        try await levelRepository.prepareLevelMO(from: layout)
        
        levelRepository.commit()
        
        return try await levelRepository.fetchLevels(levelType: .layout)
    }
}

