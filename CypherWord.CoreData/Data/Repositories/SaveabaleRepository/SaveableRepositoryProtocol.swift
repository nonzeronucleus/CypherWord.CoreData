protocol SaveableRepositoryProtocol {
//    func fetchLevels(levelType: LevelType, completion: @escaping (Result<[LevelDefinition], Error>) -> Void)
//    func saveLevels(levels: [LevelDefinition], completion: @escaping (Result<Void, Error>) -> Void)
    func fetchLevels(levelType: LevelType) async throws -> [LevelDefinition]
    func saveLevels(levels: [LevelDefinition]) async throws
}
