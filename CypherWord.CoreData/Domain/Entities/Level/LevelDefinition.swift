import Foundation


enum LevelType: String, CaseIterable, Identifiable, Hashable {
    case playable = "Games"
    case layout = "Layouts"

    var id: Self { self }
}

class LevelDefinition: Identifiable, Codable {
    var id: UUID
    var number: Int?
    var gridText: String?
    var letterMap: String?
    var letterGuesses: String?
    var attemptedLetters: String
    var numCorrectLetters: Int
    
    var levelType: LevelType {
        get {
            return letterMap == nil ? .layout : .playable
        }
    }

    init(id: UUID, number: Int, gridText: String? =  nil, letterMap: String? =  nil, attemptedLetters: String?, numCorrectLetters: Int = 0) {
        self.id = id
        self.number = number
        self.gridText = gridText
        self.letterMap = letterMap
        self.attemptedLetters = attemptedLetters ?? String(repeating: " ", count: 26)
        self.numCorrectLetters = numCorrectLetters
    }
    
    init(from level:Level) {
        self.id = level.id
        self.number = level.number
        let crosswordTransformer = CrosswordTransformer()
        
        gridText = crosswordTransformer.transformedValue(level.crossword) as? String
        if let letterMap = level.letterMap {
            self.letterMap = letterMap.toJSON()
        }
        self.letterGuesses = level.letterGuesses
        self.attemptedLetters = String(level.attemptedLetters)
        self.numCorrectLetters = level.numCorrectLetters
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.number = try container.decodeIfPresent(Int.self, forKey: .number)
        self.gridText = try container.decodeIfPresent(String.self, forKey: .gridText)
        self.letterMap = try container.decodeIfPresent(String.self, forKey: .letterMap)
        self.attemptedLetters = try container.decode(String.self, forKey: .attemptedLetters)
        self.numCorrectLetters = 0
    }
    
//    func encode(to encoder: any Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encodeIfPresent(number, forKey: .number)
//        try container.encodeIfPresent(gridText, forKey: .gridText)
//    }

    var name: String {
        if let number = number {
            return "Level \(number)"
        }
        return "Level \(id.uuidString), \(levelType)"
    }

//    func toLevelMO() -> LevelMO {
//        let model = LevelMO()
//        model.id = id
//        model.number = Int64(number)
//        model.gridText = gridText
//        model.letterMap = letterMap
//        model.numCorrectLetters = Int16(numCorrectLetters)
//        return model
//    }
}
