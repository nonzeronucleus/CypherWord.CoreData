protocol FetchLevelsUseCaseProtocol {
    func execute() async throws -> [LevelDefinition]
}
