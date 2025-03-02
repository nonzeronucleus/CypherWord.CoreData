import Testing
import Foundation
import Dependencies
@testable import CypherWord_CoreData

class DeleteLevelUseCaseTests {
    @Dependency(\.uuid) var uuid
    
    @Test("Successfully deletes a level")
    func testDeleteLevel_Success() async throws {
        let mockRepository = FakeLevelRepository()
        
        try await withDependencies { dependencies in
            dependencies.levelRepository = mockRepository
            dependencies.uuid = .incrementing
        } operation: {
            let repository = Dependency(\.levelRepository).wrappedValue
            let deleteLevelUseCase = DeleteLevelUseCase(repository: repository)
            
            let levelID = uuid()
            
            try await deleteLevelUseCase.execute(levelID: levelID)
            
            #expect(mockRepository.deletedLevelID == levelID)
        }
    }
    
    @Test("Fails to delete a level due to repository error")
    func testDeleteLevel_Failure() async throws {
        let mockRepository = FakeLevelRepository()
        mockRepository.throwErrorOnDelete = true
        
        await withDependencies { dependencies in
            dependencies.levelRepository = mockRepository
            dependencies.uuid = .incrementing
        } operation: {
            let repository = Dependency(\.levelRepository).wrappedValue
            let deleteLevelUseCase = DeleteLevelUseCase(repository: repository)
            
            let levelID = uuid()
            let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
            
            do {
                try await deleteLevelUseCase.execute(levelID: levelID)
                #expect(Bool(false), "Expected an error but no error was thrown")
            } catch {
                #expect((error as NSError).domain == expectedError.domain)
                #expect((error as NSError).code == expectedError.code)
            }
        }
    }
}
