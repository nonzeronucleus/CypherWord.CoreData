import Dependencies
class FetchPlayableLevelsUseCase: FetchLevelsUseCaseProtocol {
    @Dependency(\.levelRepository) private var repository: LevelRepositoryProtocol

    func execute(completion: @escaping (Result<[LevelDefinition], Error>) -> Void) {
        repository.fetchLevels(levelType:.playable, completion: completion)
    }
}
