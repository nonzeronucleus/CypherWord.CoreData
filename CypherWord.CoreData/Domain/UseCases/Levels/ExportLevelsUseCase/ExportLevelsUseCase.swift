import Foundation
import Dependencies

protocol ExportLevelsUseCaseProtocol {
    func execute(file: LevelFile) async throws
}

class ExportLevelsUseCase : FilesUseCase, ExportLevelsUseCaseProtocol {
    func execute(file: LevelFile) async throws {
        try await fileRepository.saveLevels(file: file)
    }
}
