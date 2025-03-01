protocol DeleteAllLevelsUseCaseProtocol {
    func execute(levelType: LevelType) async throws -> [LevelDefinition]
}
