import Testing
import Foundation
import Dependencies
@testable import CypherWord_CoreData

class ExportAllUseCaseTests {
    @Test("Successfully exports all levels")
    func testExportAll_Success() async throws {
        let mockRepository = MockFileRepository()

        await withDependencies { dependencies in
            dependencies.fileRepository = mockRepository
            dependencies.uuid = .incrementing
        } operation: {
            @Dependency(\.uuid) var uuid

            let repository = Dependency(\.fileRepository).wrappedValue
            let useCase = ExportLevelsUseCase(fileRepository: repository)

            let testLevels = [
                LevelDefinition(id: uuid(), number: 1),
                LevelDefinition(id: uuid(), number: 2)
            ]
            
            do {
                try await useCase.execute(fileDefinition: LayoutFileDefinition(), levels: testLevels)
                
                //            mockRepository.expectedSaveResult = .success(())
                
                
                
                //            try await withCheckedThrowingContinuation { continuation in
                //                useCase.execute(levels: testLevels) { result in
                //                    continuation.resume(with: result)
                //                }
                //            }
                
                #expect(mockRepository.savedLevels == testLevels)
            }
            catch {
                #expect(error == nil)
            }
        }
    }

    @Test("Fails to export levels due to repository error")
    func testExportAll_Failure() async {
        let mockRepository = MockFileRepository()
        mockRepository.throwError = true

        await withDependencies { dependencies in
            dependencies.fileRepository = mockRepository
            dependencies.uuid = .incrementing
        } operation: {
            @Dependency(\.uuid) var uuid
            
            let exportAllUseCase = ExportLevelsUseCase(fileRepository: mockRepository)

            let testLevels = [LevelDefinition(id: uuid(), number: 1)]
            let expectedError = NSError(domain: "TestError", code: 2, userInfo: nil)

            do {
                try await exportAllUseCase.execute(fileDefinition: LayoutFileDefinition(), levels: testLevels)
                
                #expect(Bool(false), "Expected an error but no error was thrown")
            } catch {
                #expect((error as NSError).domain == expectedError.domain)
                #expect((error as NSError).code == expectedError.code)
            }
        }
    }
}

final class MockFileRepository: FileRepositoryProtocol {
    func fetchLevels(fileDefinition: any CypherWord_CoreData.FileDefinitionProtocol) async throws -> [CypherWord_CoreData.LevelDefinition] {
        return []
    }
    
    func saveLevels(fileDefinition: any CypherWord_CoreData.FileDefinitionProtocol, levels: [CypherWord_CoreData.LevelDefinition]) async throws {
        if throwError {
            throw NSError(domain: "TestError", code: 2, userInfo: nil)
        }
        savedLevels = levels
    }
    
    func listPacks(levelType: CypherWord_CoreData.LevelType) async throws -> [URL] {
        print("\(#function) not implemented")
        return []
    }
    var throwError: Bool = false
    var savedPacks: [PackDefinition] = []
    var savedLevels: [LevelDefinition] = []
    var expectedSaveResult: Result<Void, Error> = .success(())
}
