import Foundation
import Dependencies

protocol ExportLevelsUseCaseProtocol {
    func execute(file: LevelFile) async throws
//    func execute(levels: [LevelDefinition]) async throws
}

class ExportLevelsUseCase : FilesUseCase, ExportLevelsUseCaseProtocol {
    func execute(file: LevelFile) async throws {
        try await fileRepository.saveLevels(file: file)
    }
    
//    func execute(levels: [LevelDefinition]) async throws {
//        try await fileRepository.saveLevels(levels: levels)
//    }

}
