import Foundation
import Dependencies

protocol AddLayoutUseCaseProtocol {
    func execute() async throws -> [LevelDefinition]
}


class AddLayoutUseCase: AddLayoutUseCaseProtocol {
    var levelRepository: LayoutRepositoryProtocol
    
    init(levelRepository: LayoutRepositoryProtocol) {
        self.levelRepository = levelRepository
    }

    func execute() async throws -> [LevelDefinition] {
        @Dependency(\.uuid) var uuid
        
        let nextNum = try levelRepository.fetchHighestLevelNumber(levelType: .layout) + 1

        let layout = LevelDefinition(
            id: uuid(),
            number: nextNum,
            packId: nil,
            attemptedLetters: ""
        )
        
        try await levelRepository.prepareLevelMO(from: layout)
        
        levelRepository.commit()
        
        return try await levelRepository.fetchLayouts()
    }
}

