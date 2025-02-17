import Foundation
import Dependencies

class AddPlayableLevelUseCase : AddPlayableLevelUseCaseProtocol {
    @Dependency(\.levelRepository) private var repository: LevelRepositoryProtocol
    
    func execute(level: LevelDefinition, completion: @escaping (Result<Void, any Error>) -> Void) {
        repository.addPlayableLevel(level: level, completion: { /*[weak self]*/ result in
            DispatchQueue.main.async {
//                guard let self = self else {
//                    return completion(.failure(
//                        OptionalUnwrappingError.foundNil("Self deallocated in AddLayoutUseCase.execute")
//                    ))
//                }
                
                switch result {
                    case .success:
                        completion(.success(()))
//                        self.repository.fetchLevels(levelType: .layout, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        })
    }
}
