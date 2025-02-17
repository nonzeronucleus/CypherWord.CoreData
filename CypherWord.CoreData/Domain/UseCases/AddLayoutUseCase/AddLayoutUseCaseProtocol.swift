protocol AddLayoutUseCaseProtocol {
    func execute(completion: @escaping (Result<[LevelDefinition], Error>) -> Void)
}
