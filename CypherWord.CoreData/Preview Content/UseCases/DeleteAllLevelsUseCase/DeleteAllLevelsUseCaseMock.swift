class DeleteAllLevelsUseCaseMock: DeleteAllLevelsUseCaseProtocol {
    func execute(levelType: LevelType) -> [LevelDefinition] {
        return []
    }
}
