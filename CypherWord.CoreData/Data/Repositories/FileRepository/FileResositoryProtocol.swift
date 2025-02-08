protocol FileRepositoryProtocol {
    func fetchLevels(levelType: Level.LevelType, completion: @escaping (Result<[Level], Error>) -> Void)
}

