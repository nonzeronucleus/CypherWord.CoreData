protocol SaveLevelUseCaseProtocol {
    func execute(level:Level, completion: @escaping (Result<Void, any Error>) -> Void)
}
