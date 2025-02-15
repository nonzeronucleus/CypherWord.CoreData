protocol FileRepositoryProtocol {
    func fetchLevels(levelType: Level.LevelType, completion: @escaping (Result<[Level], Error>) -> Void)
    func saveLevels(_ levels: [Level], completion: @escaping (Result<Void, Error>) -> Void)

}

