//import XCTest
//import SwiftUI
//import Dependencies
//@testable import CypherWord_CoreData
//
//final class CypherWord_CoreDataUITests: XCTestCase {
//    let app = XCUIApplication()
//
//    @MainActor
//    override func setUpWithError() throws {
//        let testLayouts: [LevelDefinition] = [
////            LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
////            LevelDefinition(id: UUID())
//        ]
//        
////        let testPlayableLevels = [
////            LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil),
////            LevelDefinition(id: UUID(), number: 2, attemptedLetters: nil),
////            LevelDefinition(id: UUID(), number: 3, attemptedLetters: nil),
////            LevelDefinition(id: UUID(), number: 4, attemptedLetters: nil)
////        ]
////
////        withDependencies {
////            $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
////        } operation: {
////            app.launchArguments = ["-UITesting"]
////            app.launchEnvironment["UITesting"] = "true"
////            app.launch()
////        }
//    }
//
//    @MainActor
//    func testExample() throws {
//        let title = app.staticTexts["Games2"]
//        XCTAssertTrue(title.waitForExistence(timeout: 5), "TitleBarView should display the correct title")
//    }
//}
