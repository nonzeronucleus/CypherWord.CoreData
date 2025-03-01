protocol FetchLevelsUseCaseProtocol {
//    func execute(completion: @escaping (Result<[LevelDefinition], Error>) -> Void)
    func execute() async throws -> [LevelDefinition]
}
