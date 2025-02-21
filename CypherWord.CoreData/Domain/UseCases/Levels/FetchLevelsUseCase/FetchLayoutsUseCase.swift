import Dependencies

class FetchLayoutsUseCase: LevelsUseCase, FetchLevelsUseCaseProtocol {
    func execute(completion: @escaping (Result<[LevelDefinition], Error>) -> Void) {
        levelRepository.fetchLevels(levelType:.layout, completion: completion)
    }
}
