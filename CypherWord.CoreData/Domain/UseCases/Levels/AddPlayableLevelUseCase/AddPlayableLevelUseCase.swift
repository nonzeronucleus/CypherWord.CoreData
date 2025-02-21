import Foundation
import Dependencies

class AddPlayableLevelUseCase : LevelsUseCase, AddPlayableLevelUseCaseProtocol {
    func execute(level: LevelDefinition, completion: @escaping (Result<Void, any Error>) -> Void) {
        levelRepository.addPlayableLevel(level: level, completion: { result in
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
