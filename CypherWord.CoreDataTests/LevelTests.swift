import Testing
import Foundation
import Dependencies
@testable import CypherWord_CoreData

struct LevelTests {
    
    
//    @Test func t1() async throws {
//        func countCorrectlyPlacedLetters(in attemptedLetters: String, using positionMap: [Character: Int]) -> Int {
//            guard attemptedLetters.count == 26 else {
//                print("Error: attemptedLetters must be exactly 26 characters long.")
//                return 0
//            }
//            
//            return attemptedLetters.enumerated().filter { index, letter in
//                positionMap[letter] == index
//            }.count
//        }
//
//        // Example dictionary (decoded from JSON)
//        let letterPositionMap: [Character: Int] = [
//            "T": 13, "P": 0, "S": 23, "G": 19, "A": 18, "U": 6, "F": 11, "W": 10, "Z": 14,
//            "V": 24, "K": 17, "J": 9, "H": 22, "O": 7, "E": 16, "B": 8, "D": 2, "C": 12,
//            "R": 3, "M": 4, "Q": 15, "N": 20, "Y": 25, "L": 21, "X": 5, "I": 1
//        ]
//
//        // Example string to check
//        let attemptedLetters = "PI_BDMC_FJWOGEQKTHAUNVXYLS"  // Some letters in correct positions
//
//        // Count correctly placed letters
//        let correctCount = countCorrectlyPlacedLetters(in: attemptedLetters, using: letterPositionMap)
//        print(correctCount)  // Output: Number of correctly placed letters
//    }
    
//    @Test func testNumCorrectLetters() async throws {
//        withDependencies { dependencies in
//            dependencies.uuid = .incrementing
//        } operation: {
//            @Dependency(\.uuid) var uuid
//            
//            let letterMap = """
//                {"V":21,"H":7,"X":23,"F":5,"W":22,"M":12,"E":4,"Y":24,"B":1,"Z":25,"G":6,"R":17,"T":19,"P":15,"L":11,"K":10,"D":3,"S":18,"U":20,"N":13,"A":0,"I":8,"J":9,"C":2,"O":14,"Q":16}
//            """
////            let attemptedLetters = "                       X Z"
//            let gridText = "AMAZE..E.ISLES.|.O..APPLET.A...|BIGHT..M...P...|...Y......ASHES|...E.......E..P|...N...S......A|..DAMASK..LIVER|....A..I..O....|LIVER..FLEXED..|E......F...R...|F..E.......E...|TWIXT......C...|...P...J..STONY|...E.UNIQUE..I.|.ZILCH.B..WRYLY|"
//            
//            let attemptedLetters = "AC                     X Z"
//            
//            let level = Level(id: uuid(), number: 1, gridText:gridText, letterMap: letterMap, attemptedLetters: attemptedLetters)
//            
//            #expect(level.numCorrectLetters == 3)
//        }
//    }
}
