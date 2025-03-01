import Foundation
import Dependencies

class DeleteAllLevelsUseCase: LevelsUseCase, DeleteAllLevelsUseCaseProtocol {
    func execute(levelType: LevelType) async throws -> [LevelDefinition] {
        try await levelRepository.deleteAll (levelType: levelType)
        return try await levelRepository.fetchLevels(levelType: levelType)
    }

    
    //    func execute(levelType: LevelType, completion: @escaping (Result<[LevelDefinition], any Error>) -> Void) {
//        levelRepository.deleteAll (levelType: levelType, completion: { [weak self] result in
//            DispatchQueue.main.async {
//                guard let self = self else {
//                    return completion(.failure(
//                        OptionalUnwrappingError.foundNil("Self deallocated in AddLayoutUseCase.execute")
//                    ))
//                }
//                
//                switch result {
//                case .success:
//                        self.levelRepository.fetchLevels(levelType: levelType, completion: completion)
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        })
//    }
}
