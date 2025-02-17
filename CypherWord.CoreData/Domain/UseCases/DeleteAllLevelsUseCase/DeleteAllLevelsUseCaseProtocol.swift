protocol DeleteAllLevelsUseCaseProtocol {
    func execute(levelType: LevelType, completion: @escaping (Result<[LevelDefinition], Error>) -> Void)
}
