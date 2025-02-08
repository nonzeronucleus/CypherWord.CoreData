import Dependencies

class FetchLayoutsUseCase: FetchLevelsUseCaseProtocol {
    @Dependency(\.levelRepository) private var repository: LevelRepositoryProtocol

    // Inject repository or data provider
//    private let repository: LevelRepositoryProtocol

//    init(repository: LevelRepositoryProtocol) {
//        self.repository = repository
//    }
    
    func execute(completion: @escaping (Result<[Level], Error>) -> Void) {
        repository.fetchLevels(levelType:.layout, completion: completion)
    }
}
