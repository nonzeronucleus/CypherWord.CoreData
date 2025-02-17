protocol FetchLevelsUseCaseProtocol {
    func execute(completion: @escaping (Result<[LevelDefinition], Error>) -> Void)
}
