protocol DeleteAllLevelsUseCaseProtocol {
    func execute(levelType: LevelType, completion: @escaping (Result<[Level], Error>) -> Void)
}
