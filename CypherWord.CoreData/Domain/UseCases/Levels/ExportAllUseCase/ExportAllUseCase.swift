import Foundation
import Dependencies

class ExportAllUseCase : FilesUseCase, ExportAllUseCaseProtocol {
    
    func execute(levels: [LevelDefinition]) async throws {
        try await fileRepository.saveLevels(levels: levels)
    }
}

