import Dependencies
class FetchPlayableLevelsUseCase: LevelsUseCase, FetchLevelsUseCaseProtocol {
    func execute() async throws -> [LevelDefinition] {
        return try await levelRepository.fetchLevels(levelType:.playable)
    }
}
