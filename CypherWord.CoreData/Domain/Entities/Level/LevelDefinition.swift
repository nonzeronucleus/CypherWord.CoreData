import Foundation


enum LevelType: String, CaseIterable, Identifiable, Hashable {
    case playable = "Games"
    case layout = "Layouts"

    var id: Self { self }
}

struct LevelDefinition: Identifiable, Codable, Equatable {
    var id: UUID
    var number: Int?
    var gridText: String?
    var letterMap: String?
    var attemptedLetters: String
    var numCorrectLetters: Int
    
    var levelType: LevelType {
        get {
            return letterMap == nil ? .layout : .playable
        }
    }

    init(id: UUID, number: Int, gridText: String? =  nil, letterMap: String? =  nil, attemptedLetters: String? = nil, numCorrectLetters: Int = 0) {
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
        self.attemptedLetters = String(level.attemptedLetters)
        self.numCorrectLetters = level.numCorrectLetters
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.number = try container.decodeIfPresent(Int.self, forKey: .number)
        self.gridText = try container.decodeIfPresent(String.self, forKey: .gridText)
        self.letterMap = try container.decodeIfPresent(String.self, forKey: .letterMap)
        self.attemptedLetters = try container.decode(String.self, forKey: .attemptedLetters)
        self.numCorrectLetters = 0
    }
    
    var name: String {
        if let number = number {
            return "Level \(number)"
        }
        return "Level \(id.uuidString), \(levelType)"
    }
    
    var percentComplete: Double {
        return (Double(numCorrectLetters-2) / 24.0)
    }
}
