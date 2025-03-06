import Foundation
import Dependencies

protocol ExportLevelsUseCaseProtocol {
    func execute(fileDefinition: any FileDefinitionProtocol,  levels: [LevelDefinition]) async throws
//    func execute(levels: [LevelDefinition]) async throws
}

class ExportLevelsUseCase : FilesUseCase, ExportLevelsUseCaseProtocol {
    func execute(fileDefinition: any FileDefinitionProtocol,  levels: [LevelDefinition]) async throws {
        try await fileRepository.saveLevels(fileDefinition: fileDefinition,  levels: levels)
    }
}
