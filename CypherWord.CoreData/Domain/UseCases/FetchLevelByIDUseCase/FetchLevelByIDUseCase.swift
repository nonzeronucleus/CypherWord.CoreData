import Foundation
import Dependencies

class FetchLevelByIDUseCase : FetchLevelByIDUseCaseProtocol {
    @Dependency(\.levelRepository) private var repository: LevelRepositoryProtocol

    func execute(id: UUID, completion: @escaping (Result<Level?, any Error>) -> Void) {
        repository.fetchLevelByID(id:id) { /*[weak self] */result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let levelMO):
                        if let levelMO {
                            completion(.success(LevelMapper.map(mo: levelMO)))
                        } else {
                            completion(.success(nil))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }


    func execute(id: UUID) async throws -> Level {
        return try await withCheckedThrowingContinuation { continuation in
            execute(id: id) { result in
                switch result {
                case .success(let level):
                    if let level = level {
                        continuation.resume(returning: level)
                    } else {
                        continuation.resume(throwing: NSError(domain: "LevelError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Level not found"]))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
