protocol AddPlayableLevelUseCaseProtocol {
    func execute(level: Level, completion: @escaping (Result<Void, Error>) -> Void)
}
