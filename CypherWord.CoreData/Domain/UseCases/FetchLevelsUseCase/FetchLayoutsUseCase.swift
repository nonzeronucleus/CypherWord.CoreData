import Dependencies

class FetchLayoutsUseCase: FetchLevelsUseCaseProtocol {
    @Dependency(\.levelRepository) private var repository: LevelRepositoryProtocol

    func execute(completion: @escaping (Result<[Level], Error>) -> Void) {
        repository.fetchLevels(levelType:.layout, completion: completion)
    }
}
