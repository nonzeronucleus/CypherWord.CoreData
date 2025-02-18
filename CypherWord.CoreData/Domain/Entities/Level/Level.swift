import Foundation

struct Level {
    var id: UUID
    var number: Int?
    var crossword: Crossword
    var letterMap: CharacterIntMap?
    var attemptedLetters: [Character]
    
    var numCorrectLetters: Int {
        get {
            guard let letterMap else { return -1}
            
            return letterMap.countCorrectlyPlacedLetters(in: String(attemptedLetters))
        }
    }
    
    init(definition: LevelDefinition) {
        self.id = definition.id
        self.number = definition.number
        let transformer = CrosswordTransformer()
        
        if let gridText = definition.gridText {
            guard let crossword = transformer.reverseTransformedValue(gridText) as? Crossword else {
                fatalError( "Could not configure crossword grid")
            }
            
            self.crossword = crossword
        }
        else {
            self.crossword = Crossword(rows: 15, columns: 15)
        }

        if let letterMap = definition.letterMap {
            self.letterMap = CharacterIntMap(from: letterMap)
        }
        self.attemptedLetters = Array(definition.attemptedLetters)
    }
}
