import Dependencies

class FetchLayoutsUseCase: FetchLevelsUseCaseProtocol {
    @Dependency(\.levelRepository) private var repository: LevelRepositoryProtocol

    func execute(completion: @escaping (Result<[LevelDefinition], Error>) -> Void) {
        repository.fetchLevels(levelType:.layout, completion: completion)
    }
}
