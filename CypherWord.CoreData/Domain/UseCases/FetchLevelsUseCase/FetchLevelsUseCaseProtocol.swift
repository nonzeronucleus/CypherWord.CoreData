protocol FetchLevelsUseCaseProtocol {
    func execute(completion: @escaping (Result<[Level], Error>) -> Void)
}
