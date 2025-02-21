import Foundation
import Dependencies

class ImportLevelsUseCase : ImportLevelsUseCaseProtocol {
    private var levelRepository: LevelRepositoryProtocol
    private var fileRepository: FileRepositoryProtocol
    
    init(levelRepository: LevelRepositoryProtocol,
        fileRepository: FileRepositoryProtocol)
    {
        self.levelRepository = levelRepository
        self.fileRepository = fileRepository
    }

    func execute(levelType: LevelType, completion: @escaping (Result<Void, Error>) -> Void) {
        fileRepository.fetchLevels(levelType:levelType, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let levels):
                        self?.levelRepository.saveLevels(levels:levels, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        })
    }    
}


