protocol SaveableRepositoryProtocol {
    func fetchLevels(levelType: LevelType) async throws -> [LevelDefinition]
    func saveLevels(levels: [LevelDefinition]) async throws
}
