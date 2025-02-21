protocol ExportAllUseCaseProtocol {
    func execute(levels: [LevelDefinition], completion: @escaping (Result<Void, Error>) -> Void)
}
