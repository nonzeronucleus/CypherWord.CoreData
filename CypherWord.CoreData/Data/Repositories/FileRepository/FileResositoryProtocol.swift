protocol FileRepositoryProtocol {
    func fetchLevels(levelType: LevelType, completion: @escaping (Result<[LevelDefinition], Error>) -> Void)
    func saveLevels(levels: [LevelDefinition], completion: @escaping (Result<Void, Error>) -> Void)

}

