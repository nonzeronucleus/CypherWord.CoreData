import Foundation
import Dependencies

class DeleteAllLevelsUseCase :DeleteAllLevelsUseCaseProtocol {
    @Dependency(\.levelRepository) private var repository: LevelRepositoryProtocol
    @Dependency(\.fetchLayoutsUseCase) private var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol

    func execute(levelType: LevelType, completion: @escaping (Result<[LevelDefinition], any Error>) -> Void) {
        repository.deleteAll (levelType: levelType, completion: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return completion(.failure(
                        OptionalUnwrappingError.foundNil("Self deallocated in AddLayoutUseCase.execute")
                    ))
                }
                
                switch result {
                case .success:
                        self.repository.fetchLevels(levelType: levelType, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
}
