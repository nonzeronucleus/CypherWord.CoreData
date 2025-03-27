import Foundation
import Dependencies



protocol ImportLevelsUseCaseProtocol {
//    func execute(fileDefinition: any FileDefinitionProtocol) async throws
    func execute(fileDefinition:PlayableLevelFileDefinition) async throws
    func execute(fileDefinition:LayoutFileDefinition) async throws
}

class ImportLevelsUseCase : ImportLevelsUseCaseProtocol {
    private var playableLevelRepository: PlayableLevelRepositoryProtocol
    private var layoutRepository: LayoutRepositoryProtocol
    private var fileRepository: FileRepositoryProtocol
    
    init(playableLevelRepository: PlayableLevelRepositoryProtocol,
         layoutRepository: LayoutRepositoryProtocol,
         fileRepository: FileRepositoryProtocol)
    {
        self.playableLevelRepository = playableLevelRepository
        self.layoutRepository = layoutRepository
        
        self.fileRepository = fileRepository
    }
    
    func execute(fileDefinition:PlayableLevelFileDefinition) async throws {
        let file = try await fileRepository.fetchLevels(fileDefinition: fileDefinition)
        
        for var level in file.levels {
            
            if await (try playableLevelRepository.levelExists(level:level)) {
                // Don't re-import level
                return
            }
            
            level.packId = fileDefinition.id
            
            try await playableLevelRepository.prepareLevelMO(from: level)
        }
        
        try await playableLevelRepository.writePackToManifest(playableFileDefinition: fileDefinition)

        playableLevelRepository.commit()
    }
    
    func execute(fileDefinition:LayoutFileDefinition) async throws {
        let file = try await fileRepository.fetchLevels(fileDefinition: fileDefinition)
        
        for level in file.levels {
            
            if await (try playableLevelRepository.levelExists(level:level)) {
                // Don't re-import level
                return
            }
            
            try await playableLevelRepository.prepareLevelMO(from: level)
        }
        
        playableLevelRepository.commit()
    }
    

//    func execute(fileDefinition: any FileDefinitionProtocol) async throws {
//        let file = try await fileRepository.fetchLevels(fileDefinition: fileDefinition)
//        let playableFileDefinition = file.definition as? PlayableLevelFileDefinition
//
//        
//        for var level in file.levels {
//            
//            if await (try levelRepository.levelExists(level:level)) {
//                // Don't re-import level
//                return
//            }
//            
//            if let playableFileDefinition {
//                level.packId = playableFileDefinition.id
//            }
//            
//            try await levelRepository.prepareLevelMO(from: level)
//        }
//        
//        if let playableFileDefinition {
//            try await levelRepository.writePackToManifest(playableFileDefinition: playableFileDefinition)
//        }
//
//        levelRepository.commit()
//    }
}


