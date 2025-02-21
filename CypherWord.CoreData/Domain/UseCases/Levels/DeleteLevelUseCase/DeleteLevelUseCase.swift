import Foundation
import Dependencies

class DeleteLevelUseCase :DeleteLevelUseCaseProtocol {
    private var repository: LevelRepositoryProtocol
    
    init(repository: LevelRepositoryProtocol) {
        self.repository = repository
    }

    func execute(levelID: UUID, completion: @escaping (Result<Void, any Error>) -> Void) {
        repository.delete (levelID: levelID, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                        completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
}
