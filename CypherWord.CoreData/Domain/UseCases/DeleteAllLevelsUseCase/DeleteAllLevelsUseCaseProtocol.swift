protocol DeleteAllLevelsUseCaseProtocol {
    func execute(levelType: Level.LevelType, completion: @escaping (Result<[Level], Error>) -> Void)
}
