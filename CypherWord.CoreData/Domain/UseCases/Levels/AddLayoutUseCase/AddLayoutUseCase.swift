import Foundation
import Dependencies

class AddLayoutUseCase: LevelsUseCase, AddLayoutUseCaseProtocol {
    func execute(completion: @escaping (Result<[LevelDefinition], Error>) -> Void) {
        levelRepository.addLayout { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return completion(.failure(
                        OptionalUnwrappingError.foundNil("Self deallocated in AddLayoutUseCase.execute")
                    ))
                }
                
                switch result {
                    case .success:
                        self.levelRepository.fetchLevels(levelType: .layout, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
}
