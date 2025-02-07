class FetchLevelsUseCaseMock: FetchLevelsUseCaseProtocol {
    var levels : [Level] = []
    init(levels:[Level]) {
        self.levels = levels
    }
    func execute(completion: @escaping (Result<[Level], any Error>) -> Void) {
        completion(.success(levels))
    }
}
