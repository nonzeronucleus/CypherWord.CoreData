import Foundation

class FetchLevelByIDUseCase : LevelsUseCase, FetchLevelByIDUseCaseProtocol {
    func execute(id: UUID) async throws -> LevelDefinition? {
        guard let levelMO = try await levelRepository.fetchLevelByID(id:id) else {
            return nil
        }
        return LevelMapper.map(mo: levelMO)
    }
}
