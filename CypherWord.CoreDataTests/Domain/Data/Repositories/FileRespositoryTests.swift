import Testing
import Foundation
@testable import CypherWord_CoreData

// Test Suite for FileRepository
class FileRespositoryTests {
    @Test
    func testSaveLevels() async throws {
        let temporaryDirectoryURL = try createTemporaryDirectory()
        defer { try? removeTemporaryDirectory(at: temporaryDirectoryURL) }
        
        let fileRepository = FileRepository(directoryURL: temporaryDirectoryURL)
        let levels = [
            LevelDefinition(id: UUID(), number: 1, gridText: "Grid1", letterMap: "Map1", attemptedLetters: "abc", numCorrectLetters: 3),
            LevelDefinition(id: UUID(), number: 2, gridText: "Grid2", letterMap: "Map2", attemptedLetters: "xyz", numCorrectLetters: 5)
        ]
        
        // Test saving levels
        try await withCheckedThrowingContinuation { continuation in
            fileRepository.saveLevels(levels: levels) { result in
                switch result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
        
        // Verify the file was saved
        let fileName = LevelType.playable.rawValue + ".1.json"
        let fileURL = temporaryDirectoryURL.appendingPathComponent(fileName)
        let fileExists = FileManager.default.fileExists(atPath: fileURL.path)
        #expect(fileExists == true)
        
        fileRepository.listPacks(levelType:LevelType.playable) {
            switch $0 {
                case .success(let packs):
                    print(packs)
                case .failure(let error):
                    print(error)
            }
        }

    }
    
    @Test
    func testFetchLevels() async throws {
        let temporaryDirectoryURL = try createTemporaryDirectory()
        defer { try? removeTemporaryDirectory(at: temporaryDirectoryURL) }
        
        let fileRepository = FileRepository(directoryURL: temporaryDirectoryURL)
        let levelType = LevelType.playable
        
        // Save some levels first
        let levels = [
            LevelDefinition(id: UUID(), number: 1, gridText: "Grid1", letterMap: "Map1", attemptedLetters: "abc", numCorrectLetters: 3)
        ]
        try await withCheckedThrowingContinuation { continuation in
            fileRepository.saveLevels(levels: levels) { result in
                switch result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
        
        // Test fetching levels
        let fetchedLevels: [LevelDefinition] = try await withCheckedThrowingContinuation { continuation in
            fileRepository.fetchLevels(levelType: levelType) { result in
                switch result {
                    case .success(let levels):
                        continuation.resume(returning: levels)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
        
        // Verify the fetched levels
        #expect(fetchedLevels.count == 1)
        #expect(fetchedLevels.first?.levelType == .playable)
    }
}


func createTemporaryDirectory() throws -> URL {
    let temporaryDirectoryURL = FileManager.default.temporaryDirectory
    let temporaryFolderURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(at: temporaryFolderURL, withIntermediateDirectories: true)
    return temporaryFolderURL
}

func removeTemporaryDirectory(at url: URL) throws {
    try FileManager.default.removeItem(at: url)
}
