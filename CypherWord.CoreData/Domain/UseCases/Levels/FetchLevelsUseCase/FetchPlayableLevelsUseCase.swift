import Dependencies


protocol FetchPlayableLevelsUseCaseProtocol {
    func execute(packNum: Int) async throws -> [LevelDefinition]
}


//class FetchPlayableLevelsUseCase: LevelsUseCase, FetchPlayableLevelsUseCaseProtocol {
class FetchPlayableLevelsUseCase: FetchPlayableLevelsUseCaseProtocol {
    var levelRepository: PlayableLevelRepositoryProtocol
    
    init(levelRepository: PlayableLevelRepositoryProtocol) {
        self.levelRepository = levelRepository
    }

    func execute(packNum: Int) async throws -> [LevelDefinition] {
        print("\(#file), \(#function), \(#line)")
        let levels = try await levelRepository.fetchPlayableLevels(packNum: packNum)
        
        print("\(#file), \(#function), \(#line)")
        return levels
    }
}
