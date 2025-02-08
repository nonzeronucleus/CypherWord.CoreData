class FakeLevelRepository: LevelRepositoryProtocol {
    func saveLevels(_ levels: [Level], completion: @escaping (Result<Void, any Error>) -> Void) {
        fatalError("To Implement - saveLevels")
    }
    
    func fetchLevels(levelType: Level.LevelType, completion: @escaping (Result<[Level], any Error>) -> Void) {
        if levelType == .playable {
            completion(.success(testPlayableLevels))
        }
        else {
            completion(.success(testLayouts))
        }
    }
    
    func deleteAll(levelType: Level.LevelType, completion: @escaping (Result<Void, any Error>) -> Void) {
        if levelType == .playable {
            self.testPlayableLevels = []
        }
        else {
            self.testLayouts = []
        }
        completion(.success(()))
    }
    
    
    var testLayouts: [Level]
    var testPlayableLevels: [Level]
    
    init(testLayouts: [Level] = [], testPlayableLevels: [Level] = []) {
        self.testLayouts = testLayouts
        self.testPlayableLevels = testPlayableLevels
    }
    
    func addLayout(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func save(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func saveLevel(level: Level, completion: @escaping (Result<Void, any Error>) -> Void) {
        fatalError("To Implement - saveLevel")
    }
}
