import Foundation
import Dependencies

class DeleteLevelUseCase :DeleteLevelUseCaseProtocol {
    private var repository: LevelRepositoryProtocol
    
    init(repository: LevelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(levelID: UUID) async throws {
        try await repository.delete (levelID: levelID)
    }
}
