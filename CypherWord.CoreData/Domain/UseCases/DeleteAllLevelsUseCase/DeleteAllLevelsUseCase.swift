import Foundation
import Dependencies

class DeleteAllLevelsUseCase :DeleteAllLevelsUseCaseProtocol {
    @Dependency(\.levelRepository) private var repository: LevelRepositoryProtocol
    @Dependency(\.fetchLayoutsUseCase) private var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol

    func execute(levelType: Level.LevelType, completion: @escaping (Result<[Level], any Error>) -> Void) {
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
    
//    private func save(levelType: Level.LevelType, completion: @escaping (Result<[Level], Error>) -> Void) {
//        repository.save { [weak self] result in
//            DispatchQueue.main.async {
//                guard let self = self else {
//                    return completion(.failure(
//                        OptionalUnwrappingError.foundNil("Self deallocated in AddLayoutUseCase.save")
//                    ))
//                }
//                
//                switch result {
//                case .success:
//                        self.fetchNewLayouts(levelType: levelType, completion: completion)
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//    
//    private func fetchNewLayouts(levelType: Level.LevelType, completion: @escaping (Result<[Level], Error>) -> Void) {
//        repository.fetchLevels(levelType: levelType, completion: completion)
//    }
    
    
}
