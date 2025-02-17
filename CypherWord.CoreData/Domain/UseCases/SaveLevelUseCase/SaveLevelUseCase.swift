import Dependencies

class SaveLevelUseCase : SaveLevelUseCaseProtocol {
    @Dependency(\.levelRepository) private var repository: LevelRepositoryProtocol

     func execute(level: LevelDefinition, completion: @escaping (Result<Void, any Error>) -> Void) {
         repository.saveLevel(level: level, completion: completion)
    }
}
