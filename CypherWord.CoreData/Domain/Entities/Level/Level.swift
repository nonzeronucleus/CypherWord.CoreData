import Foundation


enum LevelType: String, CaseIterable, Identifiable, Hashable {
    case playable = "Games"
    case layout = "Layouts"

    var id: Self { self }
}

class Level: Identifiable, Codable {
    var id: UUID
    var number: Int
    var gridText: String?
    var letterMap: String?
    var attemptedLetters: String
    
    var levelType: LevelType {
        get {
            return letterMap == nil ? .layout : .playable
        }
    }

    init(id: UUID, number: Int, gridText: String? =  nil, letterMap: String? =  nil, attemptedLetters: String?) { 
        self.id = id
        self.number = number
        self.gridText = gridText
        self.letterMap = letterMap
        self.attemptedLetters = attemptedLetters ?? String(repeating: " ", count: 26)
    }

    var name: String {
        return "Level \(number), \(levelType)"
    }

    func toLevelMO() -> LevelMO {
        let model = LevelMO()
        model.id = id
        model.number = Int64(number)
        model.gridText = gridText
        model.letterMap = letterMap
        return model
    }
}
