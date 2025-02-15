protocol FileRepositoryProtocol {
    func fetchLevels(levelType: LevelType, completion: @escaping (Result<[Level], Error>) -> Void)
    func saveLevels(_ levels: [Level], completion: @escaping (Result<Void, Error>) -> Void)

}

