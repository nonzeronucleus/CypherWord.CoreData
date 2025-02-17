import Foundation

class FakeLevelRepository: LevelRepositoryProtocol {
    func delete(levelID: UUID, completion: @escaping (Result<Void, any Error>) -> Void) {
        fatalError("To Implement - addPlayableLevel")
    }
    
    func fetchLevelByID(id: UUID, completion: @escaping (Result<LevelMO?, any Error>) -> Void) {
        fatalError("To Implement - addPlayableLevel")
    }
    
    func addPlayableLevel(level: LevelDefinition, completion: @escaping (Result<Void, any Error>) -> Void) {
        fatalError("To Implement - addPlayableLevel")
    }
    
    func saveLevels(levels: [LevelDefinition], completion: @escaping (Result<Void, any Error>) -> Void) {
//        fatalError("To Implement - saveLevels")
    }
    
    func fetchLevels(levelType: LevelType, completion: @escaping (Result<[LevelDefinition], any Error>) -> Void) {
        if levelType == .playable {
            completion(.success(testPlayableLevels))
        }
        else {
            completion(.success(testLayouts))
        }
    }
    
    func deleteAll(levelType: LevelType, completion: @escaping (Result<Void, any Error>) -> Void) {
        if levelType == .playable {
            self.testPlayableLevels = []
        }
        else {
            self.testLayouts = []
        }
        completion(.success(()))
    }
    
    
    var testLayouts: [LevelDefinition]
    var testPlayableLevels: [LevelDefinition]
    
    init(testLayouts: [LevelDefinition] = [], testPlayableLevels: [LevelDefinition] = []) {
        self.testLayouts = testLayouts
        self.testPlayableLevels = testPlayableLevels
    }
    
    func addLayout(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func save(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func saveLevel(level: LevelDefinition, completion: @escaping (Result<Void, any Error>) -> Void) {
        fatalError("To Implement - saveLevel")
    }
}
