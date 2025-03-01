protocol AddLayoutUseCaseProtocol {
    func execute() async throws -> [LevelDefinition]

//    func execute(completion: @escaping (Result<[LevelDefinition], Error>) -> Void)
}
