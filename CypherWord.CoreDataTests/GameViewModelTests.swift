import Testing
import Foundation
import Dependencies
@testable import CypherWord_CoreData

struct GameViewModelTests {
    

    @Test func testRevealLetterFirstLetter() async throws {
        withDependencies { dependencies in
            dependencies.uuid = .incrementing
        } operation: {
            @Dependency(\.uuid) var uuid
            
            let letterMap = """
                {"V":21,"H":7,"X":23,"F":5,"W":22,"M":12,"E":4,"Y":24,"B":1,"Z":25,"G":6,"R":17,"T":19,"P":15,"L":11,"K":10,"D":3,"S":18,"U":20,"N":13,"A":0,"I":8,"J":9,"C":2,"O":14,"Q":16}
            """
            let attemptedLetters = "                       X Z"
            let gridText = "AMAZE..E.ISLES.|.O..APPLET.A...|BIGHT..M...P...|...Y......ASHES|...E.......E..P|...N...S......A|..DAMASK..LIVER|....A..I..O....|LIVER..FLEXED..|E......F...R...|F..E.......E...|TWIXT......C...|...P...J..STONY|...E.UNIQUE..I.|.ZILCH.B..WRYLY|"
            
            var expectedAttemptedValues = "                       X Z"

            let level = Level(id: uuid(), number: 1, gridText:gridText, letterMap: letterMap, attemptedLetters: attemptedLetters)
            let gameViewModel = GameViewModel(level: level)
            
            #expect(String(gameViewModel.attemptedValues) == expectedAttemptedValues)
            var foundLetters = "XZ"
            var idx = 0
            
            var char = Array(gameViewModel.letterValues!.characterIntMap)[idx].key
            
            idx+=1
            
            while(foundLetters.contains(String(char))) {
                char = Array(gameViewModel.letterValues!.characterIntMap)[idx].key
                idx+=1
            }
            
            foundLetters.append(String(char))
            
            var alphabetPos = Int(char.asciiValue! - Character("A").asciiValue!)
            
            gameViewModel.revealLetter()
            
            expectedAttemptedValues[alphabetPos] = char
            
            // Should reveal next unrevealed letter
            #expect(String(gameViewModel.attemptedValues) == expectedAttemptedValues)
            gameViewModel.revealLetter()
            
            char = Array(gameViewModel.letterValues!.characterIntMap)[idx].key
            
            idx+=1
            
            while(foundLetters.contains(String(char))) {
                char = Array(gameViewModel.letterValues!.characterIntMap)[idx].key
                idx+=1
            }
            
            alphabetPos = Int(char.asciiValue! - Character("A").asciiValue!)

            expectedAttemptedValues[alphabetPos] = char
            
            if (String(gameViewModel.attemptedValues) != expectedAttemptedValues) {
                print(char)
            }

            #expect(String(gameViewModel.attemptedValues) == expectedAttemptedValues)
        }
    }
}
