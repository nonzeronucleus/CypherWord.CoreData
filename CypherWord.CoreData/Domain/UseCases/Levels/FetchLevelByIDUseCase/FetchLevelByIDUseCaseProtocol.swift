import Foundation

protocol FetchLevelByIDUseCaseProtocol {
    func execute(id: UUID) async throws -> LevelDefinition?
}
