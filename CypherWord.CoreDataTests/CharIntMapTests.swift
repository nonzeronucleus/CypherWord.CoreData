import Testing
import Foundation
import Dependencies
@testable import CypherWord_CoreData

struct CharIntMapTests {
    
    @Test func testCountCorrectlyPlacedLetters() async throws {
        let charIntMap: [Character: Int] = [
            "T": 13, "P": 0, "S": 23, "G": 19, "A": 18, "U": 6, "F": 11, "W": 10, "Z": 14,
            "V": 24, "K": 17, "J": 9, "H": 22, "O": 7, "E": 16, "B": 8, "D": 2, "C": 12,
            "R": 3, "M": 4, "Q": 15, "N": 20, "Y": 25, "L": 21, "X": 5, "I": 1
        ]
        
//        let charIntMap = CharacterIntMap(letterPositionMap)

        // All chars in right position
        var attemptedLetters = "PIDRMXUOBJWFCTZQEKAGNLHSVY"  // Some letters in correct positions
        
        var correctCount = charIntMap.countCorrectlyPlacedLetters(in: attemptedLetters)
        #expect(correctCount == 26)
        
        
        // No chars in right position
        attemptedLetters = "YPIDRMXUOBJWFCTZQEKAGNLHSV"  // Some letters in correct positions
        
        correctCount = charIntMap.countCorrectlyPlacedLetters(in: attemptedLetters)
        #expect(correctCount == 0)

        // HALF chars in right position and half blank
        attemptedLetters = "P D M U B W C Z E A N H V "  // Some letters in correct positions
        
//
        correctCount = charIntMap.countCorrectlyPlacedLetters(in: attemptedLetters)
        #expect(correctCount == 13)

        // HALF chars in right position and half wrong
        attemptedLetters = "PYDIMRUXBOWJCFZTEQAKNGHLVS"  // Some letters in correct positions
        
        correctCount = charIntMap.countCorrectlyPlacedLetters(in: attemptedLetters)
        #expect(correctCount == 13)

    }
}

    
