import Foundation

protocol FetchLevelByIDUseCaseProtocol {
    func execute(id: UUID, completion: @escaping (Result<LevelDefinition?, Error>) -> Void)
    func execute(id: UUID) async throws -> LevelDefinition 
}
