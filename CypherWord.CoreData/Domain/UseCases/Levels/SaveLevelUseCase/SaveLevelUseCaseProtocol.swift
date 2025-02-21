protocol SaveLevelUseCaseProtocol {
    func execute(level:LevelDefinition, completion: @escaping (Result<Void, any Error>) -> Void)
}
