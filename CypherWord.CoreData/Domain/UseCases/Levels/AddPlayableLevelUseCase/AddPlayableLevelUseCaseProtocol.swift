protocol AddPlayableLevelUseCaseProtocol {
    func execute(level: LevelDefinition, completion: @escaping (Result<Void, Error>) -> Void)
}
