import Dependencies
class FetchPlayableLevelsUseCase: LevelsUseCase, FetchLevelsUseCaseProtocol {
    func execute() async throws -> [LevelDefinition] {
        let levels = try await levelRepository.fetchLevels(levelType:.playable)
        
        return levels
    }
}
