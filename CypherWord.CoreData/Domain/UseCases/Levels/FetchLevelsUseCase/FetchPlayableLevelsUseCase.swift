import Dependencies


protocol FetchPlayableLevelsUseCaseProtocol: LevelsUseCase {
    func execute(packNum: Int) async throws -> [LevelDefinition]
}


class FetchPlayableLevelsUseCase: LevelsUseCase, FetchPlayableLevelsUseCaseProtocol {
    func execute(packNum: Int) async throws -> [LevelDefinition] {
        let levels = try await levelRepository.fetchPlayableLevels(packNum: packNum)
        
        return levels
    }
}
