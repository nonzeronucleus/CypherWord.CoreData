protocol LevelRepositoryProtocol: FileRepositoryProtocol {
    func saveLevels(_ levels: [Level], completion: @escaping (Result<Void, Error>) -> Void)
//    func fetchLevels(levelType: Level.LevelType, completion: @escaping (Result<[Level], Error>) -> Void)
    func addLayout(completion: @escaping (Result<Void, Error>) -> Void)
    func addPlayableLevel(level: Level, completion: @escaping (Result<Void, Error>) -> Void) 

    func deleteAll(levelType: Level.LevelType, completion: @escaping (Result<Void, Error>) -> Void)
    func saveLevel(level: Level, completion: @escaping (Result<Void, Error>) -> Void)
}

