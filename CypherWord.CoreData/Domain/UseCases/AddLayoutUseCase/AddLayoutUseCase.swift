import Foundation
import Dependencies

class AddLayoutUseCase: AddLayoutUseCaseProtocol {
    @Dependency(\.levelRepository) private var repository: LevelRepositoryProtocol
//    @Dependency(\.fetchLayoutsUseCase) private var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol
    
    func execute(completion: @escaping (Result<[Level], Error>) -> Void) {
        repository.addLayout { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return completion(.failure(
                        OptionalUnwrappingError.foundNil("Self deallocated in AddLayoutUseCase.execute")
                    ))
                }
                
                switch result {
                    case .success:
                        self.repository.fetchLevels(levelType: .layout, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
}
