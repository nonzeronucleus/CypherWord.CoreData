import Foundation

protocol FetchLevelByIDUseCaseProtocol {
    func execute(id: UUID, completion: @escaping (Result<Level?, Error>) -> Void)
    func execute(id: UUID) async throws -> Level 
}
