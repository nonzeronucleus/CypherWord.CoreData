protocol AddPlayableLevelUseCaseProtocol {
    func execute(level: LevelDefinition) async throws
}
