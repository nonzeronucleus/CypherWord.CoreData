import Foundation
import Dependencies

protocol DeleteAllLayoutsUseCaseProtocol {
    func execute() async throws -> [LevelDefinition]
}


class DeleteAllLayoutsUseCase: DeleteAllLayoutsUseCaseProtocol {
    var levelRepository: LayoutRepositoryProtocol
    
    init(levelRepository: LayoutRepositoryProtocol) {
        self.levelRepository = levelRepository
    }


    func execute() async throws -> [LevelDefinition] {
        try levelRepository.deleteAllLevels(levelType: .layout )
        
        levelRepository.commit()

        return try await levelRepository.fetchLayouts()
    }
}
