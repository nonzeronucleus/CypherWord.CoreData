import Foundation
import Dependencies

class FakeLevelRepository: LevelRepositoryProtocol, PlayableLevelRepositoryProtocol, LayoutRepositoryProtocol {
    func fetchHighestLevelNumber(levelType: LevelType, packId: UUID?) throws -> Int {
        return 1
    }
    
    func packExists(packDefinition: PackDefinition) async -> Bool {
        return true
    }
    
    func writePackToManifest(packDefinition: PackDefinition) async throws {
        
    }
    
    func getCurrentPackNum() -> Int {
        return 1
    }
    
    func levelExists(level: LevelDefinition) async throws -> Bool {
        return false
    }
    
    func writePackToManifest(playableFileDefinition: PlayableLevelFileDefinition) async throws {
    }
    
    func fetchPlayableLevels(packNum: Int) async throws -> [LevelDefinition] {
        return testPlayableLevels.map { $0.value }.sorted(by: { level1, level2 in
            guard let number1 = level1.number else { return false }
            guard let number2 = level2.number else { return true }

            return (number1 < number2)
        })
    }
    
    func deleteAllPacks() throws {
        fatalError("\(#function) not implemented")
    }
    
    func deleteAllLevels(levelType: LevelType) throws {
        fatalError("\(#function) not implemented")
    }
    
    func commit() {
    }
    
    func prepareLevelMO(from level: LevelDefinition) throws {
    }
    

    func getManifest() async throws -> Manifest {
        @Dependency(\.uuid) var uuid

        return Manifest(levels: [
            PackDefinition(id: uuid(), packNumber: 1),
            PackDefinition(id: uuid(), packNumber: 2)
        ])
    }
    
    func fetchLevelByID(id: UUID) async throws -> LevelMO? {
        fatalError("To Implement - addPlayableLevel")
    }
    
    func addPlayableLevel(level: LevelDefinition) async throws {
        fatalError("To Implement - addPlayableLevel")
    }
    
    func delete(levelID: UUID) async throws {
        if throwErrorOnDelete {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        deletedLevelID = levelID
    }
    
    func saveLevel(level: LevelDefinition) async throws {
        fatalError("To Implement - addPlayableLevel")
    }
    
    func addLayout() async throws {
        @Dependency(\.uuid) var uuid

        let levelDefinition = LevelDefinition(id: uuid(), number: 1, packId: uuid(), attemptedLetters: nil, numCorrectLetters: 0)
        testLayouts[levelDefinition.id] = levelDefinition
    }
    
    func deleteAll(levelType: LevelType) async throws {
        try await deleteAllLevels(levelType: levelType)
    }

    
    private func deleteAllLevels(levelType: LevelType) async throws {
        if levelType == .playable {
            self.testPlayableLevels.removeAll()
        }
        else {
            self.testLayouts.removeAll()
        }
    }
    
    func fetchLayouts() async throws -> [LevelDefinition] {
        return testLayouts.map { $0.value }.sorted(by: { level1, level2 in
            guard let number1 = level1.number else { return false }
            guard let number2 = level2.number else { return true }
            
            return (number1 < number2)
        })
    }
    
    func saveLevels(file: LevelFile) async throws {
    }
    

    var testLayouts: Dictionary<UUID, LevelDefinition>
    var testPlayableLevels: Dictionary<UUID, LevelDefinition>
    var deletedLevelID:UUID?
    var throwErrorOnDelete = false
    
    init(testLayouts: [LevelDefinition] = [], testPlayableLevels: [LevelDefinition] = []) {
        self.testLayouts = Dictionary(uniqueKeysWithValues: testLayouts.map { ($0.id, $0) })
        self.testPlayableLevels = Dictionary(uniqueKeysWithValues: testPlayableLevels.map { ($0.id, $0) })

    }
}
