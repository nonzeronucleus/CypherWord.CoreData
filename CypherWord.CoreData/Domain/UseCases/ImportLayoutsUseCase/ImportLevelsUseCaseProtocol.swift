protocol ImportLayoutsUseCaseProtocol {
    func execute(completion: @escaping (Result<[Level], Error>) -> Void)
}
