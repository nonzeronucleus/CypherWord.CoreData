import Foundation

enum FileError: Error {
    case notFound
    case other(Error)
}

class FileRepository {
}

extension FileRepository : FileRepositoryProtocol {
    func saveLevels(levels: [LevelDefinition], completion: @escaping (Result<Void, any Error>) -> Void) {
        if levels.isEmpty {
            completion(.success(()))
        }
        
        let levelType = levels.first!.levelType
        
        do {
            
            let fileName = levelType.rawValue + ".json"
            let url = try FileRepository.exportFilePath().appendingPathComponent(fileName)
            print(url.description)
            let jsonData = try JSONEncoder().encode(levels)
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
            let fName = getFileName(levelType: levelType)
            if let pathURL = Bundle.main.url(forResource: fName, withExtension: "json") {
                let jsonData = try Data(contentsOf: pathURL)
                let levels = try decoder.decode([LevelDefinition].self, from: jsonData)
                
                completion(.success(levels))
            }
            else {
                completion(.failure(FileError.notFound))
            }
        } catch {
            completion(.failure(error))
        }

    }
}


// For input from bundle
extension FileRepository {
    private func filePath() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
    }
    
    func resourceBundleName(levelType: LevelType) -> URL? {
        return Bundle.main.url(forResource: getFileName(levelType:levelType), withExtension: "json")
    }
    
    func getFileName(levelType: LevelType) -> String {
        return levelType.rawValue
    }
}

// For output to directory

extension FileRepository {
    private static func exportFilePath() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
    }
    
    
}
