protocol ImportLevelsUseCaseProtocol {
    func execute(levelType: LevelType, completion: @escaping (Result<Void, Error>) -> Void)
}
