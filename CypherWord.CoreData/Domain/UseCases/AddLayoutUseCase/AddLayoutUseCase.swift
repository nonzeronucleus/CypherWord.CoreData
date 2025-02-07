import Foundation

class AddLayoutUseCase: AddLayoutUseCaseProtocol {
    private let repository: LevelRepositoryProtocol
    private let fetchLayoutsUseCase: FetchLevelsUseCaseProtocol

    init(repository: LevelRepositoryProtocol,
         fetchLayoutsUseCase: FetchLevelsUseCaseProtocol) {
        self.repository = repository
        self.fetchLayoutsUseCase = fetchLayoutsUseCase
    }
    
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
                    self.fetchLayoutsUseCase.execute(completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
//    private func save(completion: @escaping (Result<[Level], Error>) -> Void) {
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
//                    self.fetchNewLayouts(completion: completion)
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//    
//    private func fetchNewLayouts(completion: @escaping (Result<[Level], Error>) -> Void) {
//        fetchLayoutsUseCase.execute(completion: completion)
//    }
}
