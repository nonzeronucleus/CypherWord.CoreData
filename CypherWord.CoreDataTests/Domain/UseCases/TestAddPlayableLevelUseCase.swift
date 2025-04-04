import Foundation
import Testing
import Dependencies
@testable import CypherWord_CoreData

struct AddPlayableLevelUseCaseTests {
    // MARK: - Test Cases
    
    
    @Test func testExecuteSuccessfullyCreatesLevelExistingPack() async {
        await withDependencies {
            $0.uuid = .incrementing
        } operation: {
            @Dependency(\.uuid) var uuid
            
            // Arrange
            let mockRepo = MockPlayableLevelRepository(numExistingLevels: 5)
            //        mockRepo.fetchHighestLevelNumberResult = .success(5)
            mockRepo.getManifestResult = .success(Manifest(levels: []))
            
            let sut = AddPlayableLevelUseCase(levelRepository: mockRepo)
            
            let testPack = PackDefinition(
                id: uuid(),  // 000...00
                packNumber: 1
            )
            
            let layout = LevelDefinition(
                id: uuid(),  // 000...01
                number: 0,
                packId: uuid(),  // 000...02
                gridText: "ABC\nDEF",
                letterMap: ["A":1, "B":2, "C":3].toJSONString(),
                attemptedLetters: String(repeating: " ", count: 26),
                numCorrectLetters: 0
            )
            
            // Act
            try! await sut.execute(packDefinition: testPack, layout: layout)
            
            // Assert
            #expect(mockRepo.prepareLevelMOCalled)
            #expect(mockRepo.commitCalled)
            #expect(mockRepo.writePackCalled == false)
            
            if let createdLevel = mockRepo.receivedLevel {
                #expect(createdLevel.number == 6)  // 5 + 1
                #expect(createdLevel.packId == testPack.id)
            } else {
                Issue.record("Expected LevelDefinition to be received by mock")
            }
        }
    }
    
    @Test func testExecuteSuccessfullyCreatesLevelNewPack() async {
        await withDependencies {
            $0.uuid = .incrementing
        } operation: {
            
            @Dependency(\.uuid) var uuid
            
            // Arrange
            let mockRepo = MockPlayableLevelRepository(numExistingLevels: 0)
            let sut = AddPlayableLevelUseCase(levelRepository: mockRepo)
            
            let testPack = PackDefinition(
                id: uuid(),  // 000...00
                packNumber: 2
            )
            
            let layout = LevelDefinition(
                id: uuid(),  // 000...01
                number: 0,
                packId: uuid(),  // 000...02
                gridText: "ABC\nDEF",
                letterMap: ["A":1, "B":2, "C":3].toJSONString(),
                attemptedLetters: String(repeating: " ", count: 26),
                numCorrectLetters: 0
            )
            
            // Act
            try! await sut.execute(packDefinition: testPack, layout: layout)
            
            // Assert
            #expect(mockRepo.prepareLevelMOCalled)
            #expect(mockRepo.commitCalled)
            #expect(mockRepo.writePackCalled)
            
            if let createdLevel = mockRepo.receivedLevel {
                #expect(createdLevel.number == 1)  // 5 + 1
                #expect(createdLevel.packId == testPack.id)
            } else {
                Issue.record("Expected LevelDefinition to be received by mock")
            }
        }
    }
    
    @Test func testGeneratesNewUUIDForLevel() async {
        await withDependencies {
            $0.uuid = .incrementing
        } operation: {
            
            @Dependency(\.uuid) var uuid
            
            // Arrange
            let mockRepo = MockPlayableLevelRepository(numExistingLevels: 5)
            let sut = AddPlayableLevelUseCase(levelRepository: mockRepo)
            
            let testPack = PackDefinition(
                id: uuid(),  // 000...00
                packNumber: 1
            )
            
            let layout = LevelDefinition(
                id: uuid(),  // 000...01
                number: 0,
                packId: uuid(),  // 000...02
                gridText: "ABC",
                letterMap: ["A":1].toJSONString(),
                attemptedLetters: String(repeating: " ", count: 26),
                numCorrectLetters: 0
            )
            
            // Act
            try! await sut.execute(packDefinition: testPack, layout: layout)
            
            // Assert
            if let createdLevel = mockRepo.receivedLevel {
                #expect(createdLevel.id.uuidString == "00000000-0000-0000-0000-000000000003") // Next UUID
            } else {
                Issue.record("Expected LevelDefinition to be received by mock")
            }
        }
    }
    
    @Test func testHandlesNilPackNumber() async {
        withDependencies {
            $0.uuid = .incrementing
        } operation: {
            // Arrange
            let testPack = PackDefinition(packNumber: nil)
            
            #expect(testPack.id.uuidString == "00000000-0000-0000-0000-000000000000")
        }
    }
    
    //    private func testGeneratesCorrectFilename() async {
    //        @Dependency(\.uuid) var uuid
    //
    //        // Arrange
    //        let mockRepo = MockPlayableLevelRepository()
    //        mockRepo.currentPackNum = 3
    //        let sut = AddPlayableLevelUseCase(levelRepository: mockRepo)
    //
    //        let testPack = PackDefinition(
    //            id: uuid(),
    //            packNumber: 3
    //        )
    //
    //        let layout = LevelDefinition(
    //            id: uuid(),
    //            number: 0,
    //            packId: uuid(),
    //            gridText: "ABC",
    //            letterMap: ["A":1].toJSONString(),
    //            attemptedLetters: String(repeating: " ", count: 26),
    //            numCorrectLetters: 0
    //        )
    //
    //        // Act
    //        try! await sut.execute(packDefinition: testPack, layout: layout)
    //
    //        // Assert
    ////        #expect(mockRepo.writePackCalled, "writePackToManifest should be called")
    //
    //        if let fileDef = mockRepo.receivedPlayableFileDefinition {
    //            #expect(fileDef.getFileName() == "Games.3.json")
    //        } else {
    //            Issue.record("Expected PlayableLevelFileDefinition but none was received")
    //        }
    //    }
    
    // MARK: - Mock Repository
}

extension AddPlayableLevelUseCaseTests {
    
    final class MockPlayableLevelRepository: PlayableLevelRepositoryProtocol {
        func packExists(packDefinition: CypherWord_CoreData.PackDefinition) async -> Bool {
            return numExistingLevels > 0
        }
        
        init(numExistingLevels: Int) {
            self.numExistingLevels = numExistingLevels
        }
        
        // Results
        var fetchHighestLevelNumberResult: Result<Int, Error> = .success(0)
        var fetchLevelByIDResult: Result<LevelMO?, Error> = .success(nil)
        var getManifestResult: Result<Manifest, Error> = .success(Manifest(levels: []))
        var fetchPlayableLevelsResult: Result<[LevelDefinition], Error> = .success([])
        
        // Behaviors
        var prepareLevelMOBehavior: ((LevelDefinition) async throws -> Void)?
        var levelExistsBehavior: ((LevelDefinition) async throws -> Bool)?
        var writePackBehavior: ((PackDefinition) async throws -> Void)?
        
        
        // State
        var currentPackNum: Int = 1
        var numExistingLevels: Int
        
        // Tracking
        private(set) var prepareLevelMOCalled = false
        private(set) var commitCalled = false
        private(set) var writePackCalled = false
        private(set) var receivedLevel: LevelDefinition?
        private(set) var receivedPackDefinition: PackDefinition?
        
        func prepareLevelMO(from level: LevelDefinition) async throws {
            prepareLevelMOCalled = true
            receivedLevel = level
            try await prepareLevelMOBehavior?(level)
        }
        
        func commit() { commitCalled = true }
        
        func levelExists(level: LevelDefinition) async throws -> Bool {
            try await levelExistsBehavior?(level) ?? false
        }
        
        func fetchLevelByID(id: UUID) async throws -> LevelMO? {
            try fetchLevelByIDResult.get()
        }
        
        func fetchHighestLevelNumber(levelType: LevelType) throws -> Int {
            return numExistingLevels
//            try fetchHighestLevelNumberResult.get()
        }
        
        func writePackToManifest(packDefinition: PackDefinition) async throws {
            writePackCalled = true
            receivedPackDefinition = packDefinition
            try await writePackBehavior?(packDefinition)
        }
        
        func fetchPlayableLevels(packNum: Int) async throws -> [LevelDefinition] {
            try fetchPlayableLevelsResult.get()
        }
        
        func getManifest() async throws -> Manifest {
            try getManifestResult.get()
        }
        
        func writePackToManifest(playableFileDefinition: CypherWord_CoreData.PlayableLevelFileDefinition) async throws {
            
        }
        
        func deleteAllPacks() throws {}
        func deleteAllLevels(levelType: LevelType) throws {}
        func delete(levelID: UUID) async throws {}
        func getCurrentPackNum() -> Int { currentPackNum }
    }
}

// MARK: - Helpers

extension Dictionary where Key == String, Value == Int {
    func toJSONString() -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        return try? String(data: JSONSerialization.data(withJSONObject: self), encoding: .utf8)
    }
}
