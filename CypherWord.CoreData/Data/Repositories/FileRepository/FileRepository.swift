import Foundation

enum FileError: Error {
    case notFound
    case other(Error)
}

class FileRepository {
    private let fileManager: FileManager
    private let writeDirectoryURL: URL
    private let readDirectoryURL: URL
    private let manifestFilename = "manifest.json"
    var printLocation: Bool = false

    init(fileManager: FileManager = .default, directoryURL: URL? = nil) {
        self.fileManager = fileManager
        if let directoryURL = directoryURL {
            self.writeDirectoryURL = directoryURL
            self.readDirectoryURL = directoryURL
        } else {
            do {
                self.writeDirectoryURL = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: false)
                self.readDirectoryURL = Bundle.main.bundleURL
            }
            catch {
                fatalError("Could not resolve document directory: \(error)")
            }
        }
    }
}

extension FileRepository : FileRepositoryProtocol {
    
    func saveLevels(levels: [LevelDefinition]) async throws {
        if levels.isEmpty {
            return
        }

        let levelsToSave = levels.map { level in
            var newLevel = level // Create a copy
            newLevel.attemptedLetters = String(repeating: " ", count: 26)
            return newLevel
        }

        let levelType = levelsToSave.first!.levelType

        do {
//            if levelType == .playable {
//                let manifest = try await loadPackManifest()
//
//                print(manifest)
//            }

            let fileName = levelType.rawValue + "" + ".json"
            let url = exportFilePath().appendingPathComponent(fileName)
            if printLocation {
                print("\(#file) \(#function) Saving to \(url.description)")
            }
            let jsonData = try JSONEncoder().encode(levelsToSave)
            try jsonData.write(to: url)
            return
        }
    }
    
//    func saveLevels(levels: [LevelDefinition], completion: @escaping (Result<Void, any Error>) -> Void) {
//        if levels.isEmpty {
//            completion(.success(()))
//            return
//        }
//
//        let levelsToSave = levels.map { level in
//            var newLevel = level // Create a copy
//            newLevel.attemptedLetters = String(repeating: " ", count: 26)
//            return newLevel
//        }
//
//        let levelType = levelsToSave.first!.levelType
//        
//        do {
//            if levelType == .playable {
//                let manifest = try await loadPackManifest()
//                
//                print(manifest)
//            }
//        
//            let fileName = levelType.rawValue + "" + ".json"
//            let url = exportFilePath().appendingPathComponent(fileName)
//            if printLocation {
//                print("\(#file) \(#function) Saving to \(url.description)")
//            }
//            let jsonData = try JSONEncoder().encode(levelsToSave)
//            try jsonData.write(to: url)
//            completion(.success(()))
//        }
//        catch {
//            print("Error")
//            completion(.failure(error))
//        }
//    }
    
//    func fetchLevels(levelType: LevelType, completion: @escaping (Result<[LevelDefinition], any Error>) -> Void) {
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//
//        do {
//            let fileName = getFileName(levelType: levelType) + ".json"
//            //            if let pathURL = Bundle.main.url(forResource: fName, withExtension: "json") {
//            let pathURL = importFilePath().appendingPathComponent(fileName)
//            let jsonData = try Data(contentsOf: pathURL)
//            let levels = try decoder.decode([LevelDefinition].self, from: jsonData)
//            
//            completion(.success(levels))
//        } catch {
//            completion(.failure(error))
//        }
//    }
  
    func fetchLevels(levelType: LevelType) async throws -> [LevelDefinition] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let fileName = getFileName(levelType: levelType) + ".json"
            let pathURL = importFilePath().appendingPathComponent(fileName)
            let jsonData = try Data(contentsOf: pathURL)
            let levels = try decoder.decode([LevelDefinition].self, from: jsonData)
            
            return levels
        }
    }
    
    func listPacks(levelType: LevelType, completion: @escaping (Result<[URL], any Error>) -> Void) {
        let pattern = #"Games\..*\.json"#
        let directory = importFilePath()
    
        do {
            let files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            
            // Use regex to filter files
            let regex = try NSRegularExpression(pattern: pattern)
            let filteredFiles: [URL] = files.filter { file in
                let fileName = file.lastPathComponent
                return regex.firstMatch(in: fileName, range: NSRange(location: 0, length: fileName.utf16.count)) != nil
            }
            
            completion(.success(filteredFiles))
        } catch {
            print("Error listing files: \(error)")
            completion(.failure(error))
        }
    }
    
    
    func loadPackManifest() async throws -> [PackDefinition] {
        guard let manifestURL = getManifestReadFilePath() else  {
            return []
        }
        
        do {
            let jsonData = try Data(contentsOf: manifestURL)
            
            print(jsonData)
            
            return []
        }
    }

//        return try await withCheckedThrowingContinuation { continuation in
//            loadPackManifest { result in
//                switch result {
//                case .success(let packs):
//                    continuation.resume(returning: packs)
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
    
    
//    func loadPackManifest(completion: @escaping (Result<[PackDefinition], any Error>) -> Void) {
//        guard let manifestURL = getManifestReadFilePath() else  {
//            completion(.success([]))
//        }
//        
//        do {
//            let jsonData = try Data(contentsOf: manifestURL)
//            
//            print(jsonData)
//            
//            completion(.success([]))
//        }
//        catch {
//            print("Error reading manifest file: \(error)")
//            completion(.failure(error))
//        }
//        
//    }
    
    func savePackManifest(packs: [PackDefinition], completion: @escaping (Result<Void, any Error>) -> Void) {
        
    }
}



// For input from bundle
extension FileRepository {
    
    func resourceBundleName(levelType: LevelType) -> URL? {
        return Bundle.main.url(forResource: getFileName(levelType:levelType), withExtension: "json")
    }
    
    func getFileName(levelType: LevelType) -> String {
        return levelType.rawValue
    }
}

// For output to directory

extension FileRepository {
    func exportFilePath() -> URL {
        return writeDirectoryURL
    }
    
    func importFilePath() -> URL {
        return readDirectoryURL
    }
}


// For manifest

extension FileRepository {
    
    // Get the path for reading the manifest. First try the writeable folder to see if one already exists there, as we may be editing
    // If not, get the one from the app itself
    private func getManifestReadFilePath() -> URL? {
        var readFilePath = writeDirectoryURL.appendingPathComponent("manifest.json")
        
        if fileManager.fileExists(atPath: readFilePath.path) {
            return readFilePath
        }

        readFilePath = readFilePath.appendingPathComponent("manifest.json")
        
        if fileManager.fileExists(atPath: readFilePath.path) {
            return readFilePath
        }

        
        return nil
//        return readDirectoryURL.appendingPathComponent("manifest.json")
    }
}
