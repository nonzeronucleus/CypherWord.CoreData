protocol ImportLevelsUseCaseProtocol {
    func execute(levelType: Level.LevelType, completion: @escaping (Result<Void, Error>) -> Void)
}
