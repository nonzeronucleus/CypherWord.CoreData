import Foundation
import Dependencies

class ImportLevelsUseCase : ImportLevelsUseCaseProtocol {
    private var levelRepository: LevelRepositoryProtocol
    private var fileRepository: FileRepositoryProtocol
    
    init(levelRepository: LevelRepositoryProtocol,
        fileRepository: FileRepositoryProtocol)
    {
        self.levelRepository = levelRepository
        self.fileRepository = fileRepository
    }

    func execute(levelType: LevelType) async throws {
        let levels = try await fileRepository.fetchLevels(levelType:levelType)
        
        try await levelRepository.saveLevels(levels:levels)
    }
}


