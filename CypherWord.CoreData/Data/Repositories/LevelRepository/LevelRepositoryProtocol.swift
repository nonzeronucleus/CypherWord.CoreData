protocol LevelRepositoryProtocol {
    func fetchLevels(levelType: Level.LevelType, completion: @escaping (Result<[Level], Error>) -> Void)
    func addLayout(completion: @escaping (Result<Void, Error>) -> Void)
    func save(completion: @escaping (Result<Void, Error>) -> Void)
    func deleteAll(levelType: Level.LevelType, completion: @escaping (Result<Void, Error>) -> Void)
//    func addLevel(level: Level, completion: @escaping (Result<[Level], Error>) -> Void)
}

