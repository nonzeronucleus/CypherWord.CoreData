class FetchLevelsUseCaseMock: FetchLevelsUseCaseProtocol {
    var levels : [LevelDefinition] = []
    init(levels:[LevelDefinition]) {
        self.levels = levels
    }
    func execute(completion: @escaping (Result<[LevelDefinition], any Error>) -> Void) {
        completion(.success(levels))
    }
}
