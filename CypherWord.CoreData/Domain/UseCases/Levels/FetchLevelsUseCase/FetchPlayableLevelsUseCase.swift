import Dependencies
class FetchPlayableLevelsUseCase: LevelsUseCase, FetchLevelsUseCaseProtocol {
    func execute(completion: @escaping (Result<[LevelDefinition], Error>) -> Void) {
        levelRepository.fetchLevels(levelType:.playable, completion: completion)
    }
}
