import Foundation
import Dependencies

class ExportAllUseCase : FilesUseCase, ExportAllUseCaseProtocol {
    
    func execute(levels: [LevelDefinition]) async throws {
        try await fileRepository.saveLevels(levels: levels)
    }

//    func execute(levels: [LevelDefinition], completion: @escaping (Result<Void, any Error>) -> Void) {
//        fileRepository.saveLevels(levels: levels, completion: {/* [weak self] */ result in
//            DispatchQueue.main.async {
//                switch result {
//                    case .success():
//                        completion(.success(()))
//                    case .failure(let error):
//                        completion(.failure(error))
//                }
//            }
//        })
//    }
}

