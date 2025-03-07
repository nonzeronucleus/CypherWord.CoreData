import Foundation
import Dependencies

protocol ExportLevelsUseCaseProtocol {
    func execute(levels: [LevelDefinition]) async throws
//    func execute(levels: [LevelDefinition]) async throws
}

class ExportLevelsUseCase : FilesUseCase, ExportLevelsUseCaseProtocol {
    func execute(levels: [LevelDefinition]) async throws {
        try await fileRepository.saveLevels(levels: levels)
    }
}
