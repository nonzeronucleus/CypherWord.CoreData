protocol ExportAllUseCaseProtocol {
    func execute(levels: [Level], completion: @escaping (Result<Void, Error>) -> Void)
}
