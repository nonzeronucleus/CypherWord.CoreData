import Foundation
import Dependencies

class ImportLevelsUseCase : ImportLevelsUseCaseProtocol {
    @Dependency(\.fileRepository) private var fileRepository: FileRepositoryProtocol
    @Dependency(\.levelRepository) private var levelRepository: LevelRepositoryProtocol

    func execute(levelType: LevelType, completion: @escaping (Result<Void, Error>) -> Void) {
        fileRepository.fetchLevels(levelType:levelType, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let levels):
                        self?.levelRepository.saveLevels(levels:levels, completion: completion)
//                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        })
    }
}
