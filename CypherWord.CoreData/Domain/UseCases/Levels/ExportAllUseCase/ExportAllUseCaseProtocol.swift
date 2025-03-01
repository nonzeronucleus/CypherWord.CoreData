protocol ExportAllUseCaseProtocol {
//    func execute(levels: [LevelDefinition], completion: @escaping (Result<Void, Error>) -> Void)
    func execute(levels: [LevelDefinition]) async throws
}
