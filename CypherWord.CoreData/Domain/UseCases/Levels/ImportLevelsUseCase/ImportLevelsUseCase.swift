import Foundation
import Dependencies



protocol ImportLevelsUseCaseProtocol {
    func execute(fileDefinition: FileDefinitionProtocol) async throws
}

class ImportLevelsUseCase : ImportLevelsUseCaseProtocol {
    private var levelRepository: LevelRepositoryProtocol
    private var fileRepository: FileRepositoryProtocol
    
    init(levelRepository: LevelRepositoryProtocol,
        fileRepository: FileRepositoryProtocol)
    {
        self.levelRepository = levelRepository
        self.fileRepository = fileRepository
    }

    func execute(fileDefinition: FileDefinitionProtocol) async throws {
        let levels = try await fileRepository.fetchLevels(fileDefinition: fileDefinition)
        
        try await levelRepository.saveLevels(levels:levels)
    }
}


