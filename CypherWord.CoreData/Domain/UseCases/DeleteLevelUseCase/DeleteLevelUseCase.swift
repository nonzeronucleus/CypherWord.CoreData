import Foundation
import Dependencies

class DeleteLevelUseCase :DeleteLevelUseCaseProtocol {
    @Dependency(\.levelRepository) private var repository: LevelRepositoryProtocol
    @Dependency(\.fetchLayoutsUseCase) private var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol

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
