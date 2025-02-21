import Foundation

class FakeLevelRepository: LevelRepositoryProtocol {
    var testLayouts: Dictionary<UUID, LevelDefinition>
    var testPlayableLevels: Dictionary<UUID, LevelDefinition>
    
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
            completion(.success(testPlayableLevels.map { $0.value }.sorted(by: { level1, level2 in
                guard let number1 = level1.number else { return false }
                guard let number2 = level2.number else { return true }

                return (number1 < number2)
            })))
        }
        else {
            completion(.success(testLayouts.map { $0.value }.sorted(by: { level1, level2 in
                guard let number1 = level1.number else { return false }
                guard let number2 = level2.number else { return true }

                return (number1 < number2)
            })))
        }
    }
    
    func deleteAll(levelType: LevelType, completion: @escaping (Result<Void, any Error>) -> Void) {
        if levelType == .playable {
            self.testPlayableLevels.removeAll()
        }
        else {
            self.testLayouts.removeAll()
        }
        completion(.success(()))
    }
    
    
    init(testLayouts: [LevelDefinition] = [], testPlayableLevels: [LevelDefinition] = []) {
        self.testLayouts = Dictionary(uniqueKeysWithValues: testLayouts.map { ($0.id, $0) })
        self.testPlayableLevels = Dictionary(uniqueKeysWithValues: testPlayableLevels.map { ($0.id, $0) })

    }
    
    
    func addLayout(completion: @escaping (Result<Void, Error>) -> Void) {
        let levelDefinition = LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil, numCorrectLetters: 0)
        testLayouts[levelDefinition.id] = levelDefinition
        completion(.success(()))
    }
    
    func save(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func saveLevel(level: LevelDefinition, completion: @escaping (Result<Void, any Error>) -> Void) {
        if level.levelType == .layout {
            testLayouts[level.id] = level
        }
        else {
            testPlayableLevels[level.id] = level
        }
        completion(.success(()))
    }
}
