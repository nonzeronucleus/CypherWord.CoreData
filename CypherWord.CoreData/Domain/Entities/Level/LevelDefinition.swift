import Foundation


enum LevelType: String, CaseIterable, Identifiable, Hashable {
    case playable = "Games"
    case layout = "Layouts"

    var id: Self { self }
}

struct LevelDefinition: Identifiable, Equatable, Hashable {
    var id: UUID
    var number: Int?
    var gridText: String?
    var letterMap: String?
    var attemptedLetters: String
    var numCorrectLetters: Int
    var packID: UUID?
//    var fileDefinition: any FileDefinitionProtocol
    
    var levelType: LevelType {
        get {
            return letterMap == nil ? .layout : .playable
        }
    }

    init(id: UUID, number: Int, packId:UUID? = nil, gridText: String? =  nil, letterMap: String? =  nil, attemptedLetters: String? = nil, numCorrectLetters: Int = 0) {
        self.id = id
        self.packID = packId
        self.number = number
        self.gridText = gridText
        self.letterMap = letterMap
//        self.fileDefinition = DummyFileDefinition()
        self.attemptedLetters = attemptedLetters ?? String(repeating: " ", count: 26)
        self.numCorrectLetters = numCorrectLetters
//        self.fileDefinition = (letterMap == nil) ? LayoutFileDefinition() : PlayableLevelFileDefinition(packNumber: 1)
    }
    
    init(from level:Level) {
        self.id = level.id
        self.number = level.number
        let crosswordTransformer = CrosswordTransformer()
        
        gridText = crosswordTransformer.transformedValue(level.crossword) as? String
        if let letterMap = level.letterMap {
            self.letterMap = letterMap.toJSON()
        }
        self.attemptedLetters = String(level.attemptedLetters)
        self.numCorrectLetters = level.numCorrectLetters
//        self.fileDefinition = DummyFileDefinition()
//        self.fileDefinition = (letterMap == nil) ? LayoutFileDefinition() : PlayableLevelFileDefinition(packNumber: 1)
    }
//    
//    init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(UUID.self, forKey: .id)
//        self.number = try container.decodeIfPresent(Int.self, forKey: .number)
//        self.gridText = try container.decodeIfPresent(String.self, forKey: .gridText)
//        self.letterMap = try container.decodeIfPresent(String.self, forKey: .letterMap)
//        self.attemptedLetters = try container.decode(String.self, forKey: .attemptedLetters)
//        self.numCorrectLetters = 0
//    }
//    
    var name: String {
        if let number = number {
            return "Level \(number)"
        }
        return "Level \(id.uuidString), \(levelType)"
    }
    
    var percentComplete: Double {
        return (Double(numCorrectLetters-2) / 24.0)
    }
    
    static func == (lhs: LevelDefinition, rhs: LevelDefinition) -> Bool {
        return lhs.id == rhs.id
    }
}

extension LevelDefinition: Codable {
    enum CodingKeys: String, CodingKey {
        case id, number, gridText, letterMap, attemptedLetters, numCorrectLetters, fileDefinitionType, fileDefinitionData
    }
    
    // MARK: - Codable Implementation
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.number = try container.decodeIfPresent(Int.self, forKey: .number)
        self.gridText = try container.decodeIfPresent(String.self, forKey: .gridText)
        self.letterMap = try container.decodeIfPresent(String.self, forKey: .letterMap)
        self.attemptedLetters = try container.decode(String.self, forKey: .attemptedLetters)
//        self.numCorrectLetters = try container.decode(Int.self, forKey: .numCorrectLetters)
        self.numCorrectLetters = 0
        
//        self.fileDefinition = (letterMap == nil) ? LayoutFileDefinition() : PlayableLevelFileDefinition(packNumber: 1)
        

//        // Decode fileDefinition manually
//        do {
//            let type = try container.decode(String.self, forKey: .fileDefinitionType)
//            let data = try container.decode(Data.self, forKey: .fileDefinitionData)
//            switch type {
//            case "DummyFileDefinition":
//                self.fileDefinition = try JSONDecoder().decode(DummyFileDefinition.self, from: data)
//            case "LayoutFileDefinition":
//                self.fileDefinition = try JSONDecoder().decode(LayoutFileDefinition.self, from: data)
//            case "PlayableLevelFileDefinition":
//                self.fileDefinition = try JSONDecoder().decode(PlayableLevelFileDefinition.self, from: data)
//            default:
//                throw DecodingError.dataCorruptedError(forKey: .fileDefinitionType, in: container, debugDescription: "Unknown fileDefinition type: \(type)")
//            }
//        }
//        catch {
//            self.fileDefinition = DummyFileDefinition()
//        }

    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(number, forKey: .number)
        try container.encodeIfPresent(gridText, forKey: .gridText)
        try container.encodeIfPresent(letterMap, forKey: .letterMap)
        try container.encode(attemptedLetters, forKey: .attemptedLetters)
        try container.encode(numCorrectLetters, forKey: .numCorrectLetters)

//        // Encode fileDefinition manually
//        let type: String
//        let data: Data
//
//        switch fileDefinition {
//        case let file as DummyFileDefinition:
//            type = "DummyFileDefinition"
//            data = try JSONEncoder().encode(file)
//        case let file as LayoutFileDefinition:
//            type = "LayoutFileDefinition"
//            data = try JSONEncoder().encode(file)
//        case let file as PlayableLevelFileDefinition:
//            type = "PlayableLevelFileDefinition"
//            data = try JSONEncoder().encode(file)
//        default:
//            throw EncodingError.invalidValue(fileDefinition, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Unsupported fileDefinition type"))
//        }
//
//        try container.encode(type, forKey: .fileDefinitionType)
//        try container.encode(data, forKey: .fileDefinitionData)
    }
}
