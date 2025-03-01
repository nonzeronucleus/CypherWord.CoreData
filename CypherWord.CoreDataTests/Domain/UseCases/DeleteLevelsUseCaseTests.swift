import Testing
import Foundation
import Dependencies
@testable import CypherWord_CoreData

class DeleteLevelUseCaseTests {
    @Dependency(\.uuid) var uuid

    @Test("Successfully deletes a level")
    func testDeleteLevel_Success() async throws {
        let mockRepository = MockLevelRepository()

        try await withDependencies { dependencies in
            dependencies.levelRepository = mockRepository
            dependencies.uuid = .incrementing
        } operation: {
            let repository = Dependency(\.levelRepository).wrappedValue
            let useCase = DeleteLevelUseCase(repository: repository)

            let levelID = uuid()
            mockRepository.expectedDeleteResult = .success(())

            try await withCheckedThrowingContinuation { continuation in
                useCase.execute(levelID: levelID) { result in
                    continuation.resume(with: result)
                }
            }

            #expect(mockRepository.deletedLevelID == levelID)
        }
    }

    @Test("Fails to delete a level due to repository error")
    func testDeleteLevel_Failure() async throws {
        let mockRepository = MockLevelRepository()

        await withDependencies { dependencies in
            dependencies.levelRepository = mockRepository
            dependencies.uuid = .incrementing
        } operation: {
            let repository = Dependency(\.levelRepository).wrappedValue
            let useCase = DeleteLevelUseCase(repository: repository)

            let levelID = uuid()
            let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)

            mockRepository.expectedDeleteResult = .failure(expectedError)

            do {
                try await withCheckedThrowingContinuation { continuation in
                    useCase.execute(levelID: levelID) { result in
                        continuation.resume(with: result)
                    }
                }
                #expect(Bool(false), "Expected an error but no error was thrown")
            } catch {
                #expect((error as NSError).domain == expectedError.domain)
                #expect((error as NSError).code == expectedError.code)
            }
        }
    }
}



final class MockLevelRepository: LevelRepositoryProtocol {
    func addLayout() async throws {
        
    }
    
    func deleteAll(levelType: LevelType) async throws {
        
    }
    
    func fetchLevels(levelType: CypherWord_CoreData.LevelType) async throws -> [LevelDefinition] {
        return []
    }
    
    func saveLevels(levels: [LevelDefinition]) async throws {
        
    }
    
    func listPacks(levelType: CypherWord_CoreData.LevelType, completion: @escaping (Result<[URL], any Error>) -> Void) {
        
    }
    
    func fetchLevels(levelType: CypherWord_CoreData.LevelType, completion: @escaping (Result<[CypherWord_CoreData.LevelDefinition], any Error>) -> Void) {
        
    }
    
    func saveLevels(levels: [CypherWord_CoreData.LevelDefinition], completion: @escaping (Result<Void, any Error>) -> Void) {
        
    }
    
    var deletedLevelID: UUID?
    var expectedDeleteResult: Result<Void, Error> = .success(())
    
    func delete(levelID: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        deletedLevelID = levelID
        completion(expectedDeleteResult)
    }
    
    // MARK: - Other Required Protocol Methods (Stubbed)

    func fetchLevelByID(id: UUID, completion: @escaping (Result<LevelMO?, Error>) -> Void) {
        completion(.success(nil))
    }
//
//    func addLayout(completion: @escaping (Result<Void, Error>) -> Void) {
//        completion(.success(()))
//    }
//
    func addPlayableLevel(level: LevelDefinition, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
//
//    func deleteAll(levelType: LevelType, completion: @escaping (Result<Void, Error>) -> Void) {
//        completion(.success(()))
//    }
//
    func saveLevel(level: LevelDefinition, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
}

