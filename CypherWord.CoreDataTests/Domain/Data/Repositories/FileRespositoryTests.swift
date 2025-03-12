import Testing
import Foundation
import Dependencies
@testable import CypherWord_CoreData

// Test Suite for FileRepository
class FileRespositoryTests {
    @Test
    func testSaveLayouts() async throws {
        let temporaryDirectoryURL = try createTemporaryDirectory()
        defer { try? removeTemporaryDirectory(at: temporaryDirectoryURL) }
        
        let fileRepository = FileRepository(directoryURL: temporaryDirectoryURL)
        let levels = [
            LevelDefinition(id: UUID(), number: 1, gridText: "Grid1", attemptedLetters: "abc", numCorrectLetters: 3),
            LevelDefinition(id: UUID(), number: 2, gridText: "Grid2", attemptedLetters: "xyz", numCorrectLetters: 5)
        ]
        
        // Test saving levels

        do {
            let file = LevelFile(definition: LayoutFileDefinition(), levels: levels)
            try await fileRepository.saveLevels(file: file)
            
            print(temporaryDirectoryURL)
            
            // Verify the file was saved
            let fileName = LevelType.layout.rawValue + ".json"
            let fileURL = temporaryDirectoryURL.appendingPathComponent(fileName)
            let fileExists = FileManager.default.fileExists(atPath: fileURL.path)
            #expect(fileExists == true)
            
//            let packs = try await fileRepository.listPacks(levelType:LevelType.playable)
//            print(packs)
            
        }
        catch {
            #expect(error == nil)
        }

    }
    
    
    @Test
    func testFetchLayouts() async throws {
        let temporaryDirectoryURL = try createTemporaryDirectory()
        defer { try? removeTemporaryDirectory(at: temporaryDirectoryURL) }
        
        let fileRepository = FileRepository(directoryURL: temporaryDirectoryURL)
        
        // Save some levels first
        let levels = [
            LevelDefinition(id: UUID(), number: 1, gridText: "Grid1", attemptedLetters: "abc", numCorrectLetters: 3)
        ]
        
        try await fileRepository.saveLevels(file: LevelFile(definition: LayoutFileDefinition(), levels: levels))
        
        // Test fetching levels
        
        let fetchedLevelFile = try await fileRepository.fetchLevels(fileDefinition: LayoutFileDefinition())
        
        // Verify the fetched levels
        #expect(fetchedLevelFile.levels.count == 1)
        #expect(fetchedLevelFile.levels.first?.levelType == .layout)
    }
    
    
    @Test
    func testSavePlayableLevels() async throws {
        try await withDependencies  { dependencies in
            dependencies.uuid = .incrementing
        } operation: {
            
            
            
            let temporaryDirectoryURL = try createTemporaryDirectory()
            defer { try? removeTemporaryDirectory(at: temporaryDirectoryURL) }
            
            let fileRepository = FileRepository(directoryURL: temporaryDirectoryURL)
            let levels = [
                LevelDefinition(id: UUID(), number: 1, gridText: "Grid1", letterMap: "Map1", attemptedLetters: "abc", numCorrectLetters: 3),
                LevelDefinition(id: UUID(), number: 2, gridText: "Grid2", letterMap: "Map2", attemptedLetters: "xyz", numCorrectLetters: 5)
            ]
            
            // Test saving levels
            
            do {
                let file = LevelFile(definition: PlayableLevelFileDefinition(packNumber: 1), levels: levels)

                try await fileRepository.saveLevels(file:file)
                
                print(temporaryDirectoryURL)
                
                // Verify the file was saved
                var fileName = "Games.1.json"
                var fileURL = temporaryDirectoryURL.appendingPathComponent(fileName)
                var fileExists = FileManager.default.fileExists(atPath: fileURL.path)
                #expect(fileExists == true)
                
                
                // Verify the manifest was created
                fileName = "Manifest.json"
                fileURL = temporaryDirectoryURL.appendingPathComponent(fileName)
                fileExists = FileManager.default.fileExists(atPath: fileURL.path)
                #expect(fileExists == true)
                
                
                //            let packs = try await fileRepository.listPacks(levelType:LevelType.playable)
                //            print(packs)
                
            }
            catch {
                #expect(error == nil)
            }
        }
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
