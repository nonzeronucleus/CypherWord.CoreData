protocol LevelRepositoryProtocol {
    func fetchLevels(levelType: Level.LevelType, completion: @escaping (Result<[Level], Error>) -> Void)
    func addLayout(completion: @escaping (Result<[Level], Error>) -> Void)
//    func addLevel(level: Level, completion: @escaping (Result<[Level], Error>) -> Void)
}

