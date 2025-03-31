import Foundation

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
    var printLocation: Bool = true

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
            
            try await writeToFile(fileDefinition: fileDefinition, levels: levels)
        }
    }
}



// Saving - saves to document folder

extension FileRepository {
    private func writeToFile(fileDefinition: any FileDefinitionProtocol, levels: [LevelDefinition]) async throws {
        if let fileDefinition = fileDefinition as? LayoutFileDefinition {
            try await writeToFile(fileDefinition: fileDefinition, levels: levels)
        }
        
        if let fileDefinition = fileDefinition as? PlayableLevelFileDefinition {
            try await writeToFile(fileDefinition: fileDefinition, levels: levels)
        }
    }
    
    private func writeToFile(fileDefinition: LayoutFileDefinition, levels: [LevelDefinition]) async throws {
        if levels.isEmpty {
            return
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
        }
    }
    
    
    private func writeToFile(fileDefinition:PlayableLevelFileDefinition, levels: [LevelDefinition]) async throws {
        var manifest: [Int:UUID]? = nil
        if levels.isEmpty {
            return
        }
        
        try await manifest = readManifestFile(fileName: fileDefinition.manifestFileName)
        
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
            
            guard var manifest else {
                throw FileError.manifestMissing("#\(#function) at #\(#line) ")
            }
            if let packNumber = fileDefinition.packNumber {
                manifest[packNumber] = fileDefinition.id
                try await writeManifestFile(fileName: fileDefinition.manifestFileName, manifest: manifest)
            }
            else {
                fatalError("\(#file) \(#function) at \(#line) - no pack number")
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
