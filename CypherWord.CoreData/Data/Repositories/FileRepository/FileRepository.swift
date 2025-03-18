import Foundation

//typealias Manifest = [Pack]


protocol FileRepositoryProtocol {
    func fetchLevels(fileDefinition: any FileDefinitionProtocol) async throws -> LevelFile
    func saveLevels(file:LevelFile) async throws
}



enum FileError: Error {
    case notFound
    case manifestMissing(String)
    case other(Error)
}


// Init

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





// Public interface functions

extension FileRepository: FileRepositoryProtocol {
    func fetchLevels(fileDefinition: any FileDefinitionProtocol) async throws -> LevelFile {
        return try await LevelFile(definition: fileDefinition, levels: readFromFile(fileDefinition: fileDefinition))
    }
    
    func saveLevels(file:LevelFile) async throws {
        let levels = file.levels
        if let fileDefinition = file.definition {
            
            guard levels.count > 0 else {
                return
            }
            
            //        let fileDefinition = levels[0].fileDefinition
            
            try await writeToFile(fileDefinition: fileDefinition, levels: levels)
        }
    }
}



// Saving - saves to document folder

extension FileRepository {
    private func writeToFile(fileDefinition: any FileDefinitionProtocol, levels: [LevelDefinition]) async throws {
        var manifest: [Int:UUID]? = nil
        if levels.isEmpty {
            return
        }
        
        if let playableLevel = fileDefinition as? PlayableLevelFileDefinition {
            try await manifest = readManifestFile(fileName: playableLevel.manifestFileName)
        }
        
        let levelsToSave = levels.map { level in
            var newLevel = level // Create a copy
            newLevel.attemptedLetters = String(repeating: " ", count: 26)
            return newLevel
        }
        
        do {
            let fileName = fileDefinition.getFileName()
            let url = writeDirectoryURL.appendingPathComponent(fileName)
            
            if printLocation {
                print("\(#file) \(#function) Saving to \(url.description)")
            }
            let jsonData = try JSONEncoder().encode(levelsToSave)
            try jsonData.write(to: url)
            
            if let playableLevel = fileDefinition as? PlayableLevelFileDefinition {
                guard var manifest else {
                    throw FileError.manifestMissing("#\(#function) at #\(#line) ")
                }
                manifest[playableLevel.packNumber] = playableLevel.id
                
                try await writeManifestFile(fileName: playableLevel.manifestFileName, manifest: manifest)
            }
        }
    }
    
    
    private func writeManifestFile(fileName: String, manifest: [Int:UUID]) async throws {
        do {
            let url = writeDirectoryURL.appendingPathComponent(fileName)
            
            if printLocation {
                print("\(#file) \(#function) Saving to \(url.description)")
            }
            let jsonData = try JSONEncoder().encode(manifest)
            try jsonData.write(to: url)
        }
    }
}

// Loading - loads from app resource, so it can be bundled with app

extension FileRepository {
    private func readFromFile(fileDefinition: any FileDefinitionProtocol) async throws -> [LevelDefinition] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let fileName = fileDefinition.getFileName()
            let url = readDirectoryURL.appendingPathComponent(fileName)
            
            let jsonData = try Data(contentsOf: url)
            let levels = try decoder.decode([LevelDefinition].self, from: jsonData)
            
            return levels
        }
    }

    private func readManifestFile(fileName: String) async throws -> [Int:UUID] {
        if let manifestFileURL = findManifestFileURL() {
            let decoder = JSONDecoder()
            let jsonData = try Data(contentsOf: manifestFileURL)
            let manifest: [Int:UUID] = try decoder.decode([Int:UUID].self, from: jsonData)
            
            print("Loaded manifest: \(manifest)")
            
            return manifest
        }
        
        return [:]
    }
    
    private func findManifestFileURL() -> URL? {
        var readFilePath = writeDirectoryURL.appendingPathComponent("Manifest.json")

        if fileManager.fileExists(atPath: readFilePath.path) {
            return readFilePath
        }

        readFilePath = readFilePath.appendingPathComponent("Manifest.json")

        if fileManager.fileExists(atPath: readFilePath.path) {
            return readFilePath
        }

        return nil
    }
}










//
//class FileRepository {
//    private let fileManager: FileManager
//    private let writeDirectoryURL: URL
//    private let readDirectoryURL: URL
//    private let manifestFilename = "manifest.json"
//    var printLocation: Bool = false
//
//    init(fileManager: FileManager = .default, directoryURL: URL? = nil) {
//        self.fileManager = fileManager
//        if let directoryURL = directoryURL {
//            self.writeDirectoryURL = directoryURL
//            self.readDirectoryURL = directoryURL
//        } else {
//            do {
//                self.writeDirectoryURL = try FileManager.default.url(for: .documentDirectory,
//                                                                in: .userDomainMask,
//                                                                appropriateFor: nil,
//                                                                create: false)
//                self.readDirectoryURL = Bundle.main.bundleURL
//            }
//            catch {
//                fatalError("Could not resolve document directory: \(error)")
//            }
//        }
//    }
//}
//
//extension FileRepository : FileRepositoryProtocol {
//    func saveLayouts(levels: [LevelDefinition]) async throws {
//        if levels.isEmpty {
//            return
//        }
//
//        let levelsToSave = levels.map { level in
//            var newLevel = level // Create a copy
//            newLevel.attemptedLetters = String(repeating: " ", count: 26)
//            return newLevel
//        }
//
//        do {
//            let fileName = getLayoutFileName()     //LevelType.layout.rawValue + "" + ".json"
//            let url = exportFilePath().appendingPathComponent(fileName)
//            
//            if printLocation {
//                print("\(#file) \(#function) Saving to \(url.description)")
//            }
//            let jsonData = try JSONEncoder().encode(levelsToSave)
//            try jsonData.write(to: url)
//
//            return
//        }
//    }
//    
////    
//    func savePlayableLevels(levels: [LevelDefinition], packNumber: Int) async throws {
//        if levels.isEmpty {
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
////            var manifest:[PackDefinition] = []
////            
////            if levelType == .playable {
////                manifest = try await loadPackManifest()
////            }
//
//            let url = getFilePath(levelType: levelType, packNum: packNumber)
//            
//            //levelType.rawValue + "" + ".json"
////            let url = exportFilePath().appendingPathComponent(fileName)
//            if printLocation {
//                print("\(#file) \(#function) Saving to \(url.description)")
//            }
//            let jsonData = try JSONEncoder().encode(levelsToSave)
//            try jsonData.write(to: url)
//            
//            if levelType == .playable {
////                manifest
////                try await
//            }
//
//            return
//        }
//    }
//    
//    
//    func fetchLevels(levelType: LevelType, packNumber: Int) async throws -> [LevelDefinition] {
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//
//        do {
////            let fileName = getFileName(levelType: levelType) + ".json"
//            let fileName = getPlayableFileName(levelType: levelType, packNum: packNumber)
//            let url = importFilePath().appendingPathComponent(fileName)
//
//            let jsonData = try Data(contentsOf: url)
//            let levels = try decoder.decode([LevelDefinition].self, from: jsonData)
//            
//            return levels
//        }
//    }
//    
//    func loadPackManifest() async throws -> [PackDefinition] {
//        guard let manifestURL = getManifestReadFilePath() else  {
//            return []
//        }
//        
//        do {
//            let jsonData = try Data(contentsOf: manifestURL)
//            
//            print(jsonData)
//            
//            return []
//        }
//    }
//    
//    func listPacks(levelType: LevelType) async throws -> [URL] {
//        let pattern = #"Games\..*\.json"#
//        let directory = importFilePath()
//        
//        let files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
//        
//        // Use regex to filter files
//        let regex = try NSRegularExpression(pattern: pattern)
//        let filteredFiles: [URL] = files.filter { file in
//            let fileName = file.lastPathComponent
//            return regex.firstMatch(in: fileName, range: NSRange(location: 0, length: fileName.utf16.count)) != nil
//        }
//        
//        return filteredFiles
//    }
//    
//    func getPlayableFileName(levelType: LevelType, packNum: Int) -> String {
//        return "\(levelType.rawValue).\(packNum).json"
//        
//        //getFileName(levelType: levelType) + ".json"
////        return importFilePath().appendingPathComponent(fileName)
//    }
//    
//    
//}
//
//
//
//// For input from bundle
//extension FileRepository {
//    
//    func resourceBundleName(levelType: LevelType) -> URL? {
//        return Bundle.main.url(forResource: getLayoutFileName(levelType:levelType), withExtension: "json")
//    }
//    
//    func getLayoutFileName(levelType: LevelType) -> String {
//        return levelType.rawValue
//    }
//}
//
//// For output to directory
//
//extension FileRepository {
//    func exportFilePath() -> URL {
//        return writeDirectoryURL
//    }
//    
//    func importFilePath() -> URL {
//        return readDirectoryURL
//    }
//}
//
//
//
//
//
//
//
//// For manifest
//
//extension FileRepository {
//    
//    // Get the path for reading the manifest. First try the writeable folder to see if one already exists there, as we may be editing
//    // If not, get the one from the app itself
//    private func getManifestReadFilePath() -> URL? {
//        var readFilePath = writeDirectoryURL.appendingPathComponent("manifest.json")
//        
//        if fileManager.fileExists(atPath: readFilePath.path) {
//            return readFilePath
//        }
//
//        readFilePath = readFilePath.appendingPathComponent("manifest.json")
//        
//        if fileManager.fileExists(atPath: readFilePath.path) {
//            return readFilePath
//        }
//        
//        return nil
//    }
//    
//    private func getManifestWriteFilePath() -> URL {
//        return writeDirectoryURL.appendingPathComponent("manifest.json")
//    }
//}
