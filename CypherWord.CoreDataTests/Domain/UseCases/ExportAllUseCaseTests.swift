import Testing
import Foundation
import Dependencies
@testable import CypherWord_CoreData

class ExportAllUseCaseTests {
    @Test("Successfully exports all levels")
    func testExportAll_Success() async throws {
        let mockRepository = MockFileRepository()

        try await withDependencies { dependencies in
            dependencies.fileRepository = mockRepository
            dependencies.uuid = .incrementing
        } operation: {
            @Dependency(\.uuid) var uuid

            let repository = Dependency(\.fileRepository).wrappedValue
            let useCase = ExportAllUseCase(fileRepository: repository)

            let testLevels = [
                LevelDefinition(id: uuid(), number: 1),
                LevelDefinition(id: uuid(), number: 2)
            ]
            mockRepository.expectedSaveResult = .success(())

            try await withCheckedThrowingContinuation { continuation in
                useCase.execute(levels: testLevels) { result in
                    continuation.resume(with: result)
                }
            }

            #expect(mockRepository.savedLevels == testLevels)
        }
    }

    @Test("Fails to export levels due to repository error")
    func testExportAll_Failure() async {
        let mockRepository = MockFileRepository()

        await withDependencies { dependencies in
            dependencies.fileRepository = mockRepository
            dependencies.uuid = .incrementing
        } operation: {
            @Dependency(\.uuid) var uuid

            let repository = Dependency(\.fileRepository).wrappedValue
            let useCase = ExportAllUseCase(fileRepository: repository)

            let testLevels = [LevelDefinition(id: uuid(), number: 1)]
            let expectedError = NSError(domain: "TestError", code: 2, userInfo: nil)

            mockRepository.expectedSaveResult = .failure(expectedError)

            do {
                try await withCheckedThrowingContinuation { continuation in
                    useCase.execute(levels: testLevels) { result in
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

final class MockFileRepository: FileRepositoryProtocol {
    func listPacks(levelType: CypherWord_CoreData.LevelType, completion: @escaping (Result<[URL], any Error>) -> Void) {
        print("\(#function) not implemented")
    }
    
    var savedPacks: [PackDefinition] = []
    var savedLevels: [LevelDefinition] = []
    var expectedSaveResult: Result<Void, Error> = .success(())

    func saveLevels(levels: [LevelDefinition], completion: @escaping (Result<Void, Error>) -> Void) {
        savedLevels = levels
        completion(expectedSaveResult)
    }

    // MARK: - Stubbed Protocol Methods
    func fetchLevels(levelType: LevelType, completion: @escaping (Result<[LevelDefinition], any Error>) -> Void) {
        completion(.success([]))
    }
}
