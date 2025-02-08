import Foundation

enum FileError: Error {
    case notFound
    case other(Error)
}

extension LevelRepositoryFile : LevelRepositoryProtocol {
    func fetchLevels(levelType: Level.LevelType, completion: @escaping (Result<[Level], any Error>) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let fName = getFileName(levelType: levelType)
            if let pathURL = Bundle.main.url(forResource: fName, withExtension: "json") {
                let jsonData = try Data(contentsOf: pathURL)
                let levels = try decoder.decode([Level].self, from: jsonData)
                
                completion(.success(levels))
            }
            else {
                completion(.failure(FileError.notFound))
            }
        } catch {
            completion(.failure(error))
        }

    }
    
    func addLayout(completion: @escaping (Result<Void, any Error>) -> Void) {
        fatalError("Not implemented")
    }
    
    func save(completion: @escaping (Result<Void, any Error>) -> Void) {
        fatalError("Not implemented")
    }
    
    func deleteAll(levelType: Level.LevelType, completion: @escaping (Result<Void, any Error>) -> Void) {
        fatalError("Not implemented")
    }
    
    func saveLevel(level: Level, completion: @escaping (Result<Void, any Error>) -> Void) {
        
    }
}

class LevelRepositoryFile {
    private func filePath() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
    }
    
    func resourceBundleName(levelType: Level.LevelType) -> URL? {
        return Bundle.main.url(forResource: getFileName(levelType: levelType), withExtension: "json")
    }
    
    func getFileName(levelType: Level.LevelType) -> String {
        switch(levelType) {
            case .playable:
                return "Level"
            case .layout:
                return "Layout"
        }
    }
}
