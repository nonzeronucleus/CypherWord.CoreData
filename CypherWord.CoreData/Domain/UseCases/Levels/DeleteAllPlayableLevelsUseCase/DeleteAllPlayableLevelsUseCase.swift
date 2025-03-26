import Foundation
import Dependencies

protocol DeleteAllPlayableLevelsUseCaseProtocol {
    func execute(packNum:Int) async throws -> [LevelDefinition]
}

//    class DeleteAllPlayableLevelsUseCase: LevelsUseCase, DeleteAllPlayableLevelsUseCaseProtocol {

class DeleteAllPlayableLevelsUseCase: DeleteAllPlayableLevelsUseCaseProtocol {
    var levelRepository: PlayableLevelRepositoryProtocol
    
    init(levelRepository: PlayableLevelRepositoryProtocol) {
        self.levelRepository = levelRepository
    }
    
    func execute(packNum:Int) async throws -> [LevelDefinition] {
        try levelRepository.deleteAllLevels(levelType: .playable) // (packNum: packNum)
        
        try levelRepository.deleteAllPacks()
        
        levelRepository.commit()
        return try await levelRepository.fetchPlayableLevels(packNum: packNum)
    }
}
