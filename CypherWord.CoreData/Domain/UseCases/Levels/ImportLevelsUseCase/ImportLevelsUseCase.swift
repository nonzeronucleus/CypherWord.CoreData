import Foundation
import Dependencies



protocol ImportLevelsUseCaseProtocol {
    func execute(fileDefinition: any FileDefinitionProtocol) async throws
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

    func execute(fileDefinition: any FileDefinitionProtocol) async throws {
        let file = try await fileRepository.fetchLevels(fileDefinition: fileDefinition)
        
//        for level in file.levels {
//            levelRepository.
//        }
        
//        let file = LevelFile(definition: fileDefinition, levels: levels)
        
        try await levelRepository.saveLevels(file:file)
    }
//    func execute(fileDefinition: any FileDefinitionProtocol) async throws {
//        let levels = try await fileRepository.fetchLevels(fileDefinition: fileDefinition)
//        
//        try await levelRepository.saveLevels(levels:levels)
//    }
}


