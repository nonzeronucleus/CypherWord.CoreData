import Foundation

class Level {
    var id: UUID
    var number: Int?
    var crossword: Crossword
    var letterMap: CharacterIntMap?
    var letterGuesses: String?
    var attemptedLetters: [Character]
    var numCorrectLetters: Int {
        get {
            guard let letterMap else { return 0}
            guard let letterGuesses else { return 0}
            
            return letterMap.countCorrectlyPlacedLetters(in: letterGuesses)
        }
    }
    
    init(definition: LevelDefinition) {
        self.id = definition.id
        self.number = definition.number
        let transformer = CrosswordTransformer()
        
        guard let gridText = definition.gridText else {
            fatalError( "Could not load crossword grid")
        }

        guard let crossword = transformer.reverseTransformedValue(gridText) as? Crossword else {
            fatalError( "Could not configure crossword grid")
        }
        
        self.crossword = crossword

        if let letterMap = definition.letterMap {
            self.letterMap = CharacterIntMap(from: letterMap)
        }
        self.letterGuesses = definition.letterGuesses
        self.attemptedLetters = Array(definition.attemptedLetters)
    }
}
