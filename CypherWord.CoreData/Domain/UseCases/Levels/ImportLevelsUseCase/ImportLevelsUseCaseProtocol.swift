protocol ImportLevelsUseCaseProtocol {
//    func execute(levelType: LevelType, completion: @escaping (Result<Void, Error>) -> Void)
    func execute(levelType: LevelType) async throws
}
