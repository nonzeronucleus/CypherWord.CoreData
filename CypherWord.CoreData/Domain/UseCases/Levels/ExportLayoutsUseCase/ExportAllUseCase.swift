import Foundation
import Dependencies

protocol ExportLayoutsUseCaseProtocol {
    func execute(levels: [LevelDefinition]) async throws
}

class ExportLayoutsUseCase : FilesUseCase, ExportLayoutsUseCaseProtocol {
    
    func execute(levels: [LevelDefinition]) async throws {
        try await fileRepository.saveLevels(levels: levels)
    }
}

//
//import Foundation
//import Dependencies
//
//protocol ExportLayoutsUseCaseProtocol {
//    func execute(levels: [LevelDefinition]) async throws
//}
//
//class ExportLayoutsUseCase : FilesUseCase, ExportLayoutsUseCaseProtocol {
//    
//    func execute(levels: [LevelDefinition]) async throws {
////        try await fileRepository.saveLevels(levels: levels)
//    }
//}
//

