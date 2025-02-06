protocol AddLayoutUseCaseProtocol {
    func execute(completion: @escaping (Result<[Level], Error>) -> Void)
}
