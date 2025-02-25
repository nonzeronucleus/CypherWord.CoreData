import Foundation

enum FileError: Error {
    case notFound
    case other(Error)
}

class FileRepository {
    private let fileManager: FileManager
    private let writeDirectoryURL: URL
    private let readDirectoryURL: URL

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
    func saveLevels(levels: [LevelDefinition], completion: @escaping (Result<Void, any Error>) -> Void) {
        if levels.isEmpty {
            completion(.success(()))
            return
        }

        let levelsToSave = levels.map { level in
            var newLevel = level // Create a copy
            newLevel.attemptedLetters = String(repeating: " ", count: 26)
            return newLevel
        }

        let levelType = levelsToSave.first!.levelType
        
        do {
            let fileName = levelType.rawValue + ".json"
            let url = exportFilePath().appendingPathComponent(fileName)
            print(url.description)
            let jsonData = try JSONEncoder().encode(levelsToSave)
            try jsonData.write(to: url)
            completion(.success(()))
        }
        catch {
            print("Error")
            completion(.failure(error))
        }
    }
    
    func fetchLevels(levelType: LevelType, completion: @escaping (Result<[LevelDefinition], any Error>) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let fileName = getFileName(levelType: levelType) + ".json"
            //            if let pathURL = Bundle.main.url(forResource: fName, withExtension: "json") {
            let pathURL = importFilePath().appendingPathComponent(fileName)
            let jsonData = try Data(contentsOf: pathURL)
            let levels = try decoder.decode([LevelDefinition].self, from: jsonData)
            
            completion(.success(levels))
        } catch {
            completion(.failure(error))
        }

    }
}


// For input from bundle
extension FileRepository {
//    private func filePath() throws -> URL {
//        try FileManager.default.url(for: .documentDirectory,
//                                    in: .userDomainMask,
//                                    appropriateFor: nil,
//                                    create: false)
//    }
    
    func resourceBundleName(levelType: LevelType) -> URL? {
        return Bundle.main.url(forResource: getFileName(levelType:levelType), withExtension: "json")
    }
    
    func getFileName(levelType: LevelType) -> String {
        return levelType.rawValue
    }
}

// For output to directory

extension FileRepository {
//    static func exportFilePath() throws -> URL {
//        try FileManager.default.url(for: .documentDirectory,
//                                    in: .userDomainMask,
//                                    appropriateFor: nil,
//                                    create: false)
//    }
    func exportFilePath() -> URL {
        return writeDirectoryURL
    }
    
    func importFilePath() -> URL {
        return readDirectoryURL
    }

}
