import Testing
import Foundation
import Dependencies
@testable import CypherWord_CoreData


struct ResizeTests {
    
    
    @Test("Resizing grid to a larger size centers original content")
    func testResizeGrid_GrowLarger() async throws {
        await withDependencies { dependencies in
            dependencies.uuid = .incrementing
        } operation: {
            do {
                // Given: A 3x3 grid with specific values
                var grid = Crossword(rows: 3, columns: 3)
                grid[0, 0].letter = "A"
                grid[1, 1].letter = "B"
                grid[2, 2].letter = "C"
                
                // When: Resizing to a 5x5 grid
                let result = try await resizeGrid(inputGrid: grid, newSize: 5)

                #expect(result[1, 1].letter == "A")  // Example expectation
                #expect(result[2, 2].letter == "B")
                #expect(result[3, 3].letter == "C")
            }
            catch let error {
                #expect(error == nil)
                //            Issue.record("Error resizing grid: \(error)")
            }
        }
        
    }
    
    @Test("Resizing grid to a smaller size centers original content")
    func testResizeGrid_ShrinkSmaller() async throws {
        await withDependencies { dependencies in
            dependencies.uuid = .incrementing
        } operation: {
            do {
                
                // Given: A 5x5 grid with values
                var grid = Crossword(rows: 5, columns: 5)
                grid[1, 1].letter = "A"
                grid[2, 2].letter = "B"
                grid[3, 3].letter = "C"
                
                // When: Resizing to a 3x3 grid
                let result = try await resizeGrid(inputGrid: grid, newSize: 3)
                
                // Then: Validate new positioning
                #expect(result[0, 0].letter == "A")  // Shifted back
                #expect(result[1, 1].letter == "B")
                #expect(result[2, 2].letter == "C")
                
                #expect(result.rows == 3)
                #expect(result.columns == 3)
            }
            catch let error {
                #expect(error == nil)
                //            Issue.record("Error resizing grid: \(error)")
            }
        }
    }
    
    @Test("Resizing grid to the same size retains original content")
    func testResizeGrid_SameSize() async throws {
        await withDependencies { dependencies in
            dependencies.uuid = .incrementing
        } operation: {
            do {
                
                // Given: A 4x4 grid
                var grid = Crossword(rows: 4, columns: 4)
                grid[1, 1].letter = "X"
                
                // When: Resizing to the same size
                let result = try await resizeGrid(inputGrid: grid, newSize: 4)
                
                // Then: Ensure nothing changes
                #expect(result[1, 1].letter == "X")
                #expect(result.rows == 4)
                #expect(result.columns == 4)
            }
            catch let error {
                #expect(error == nil)
                //            Issue.record("Error resizing grid: \(error)")
            }
        }
    }
    
    // Helper function to handle completion-based async function
    private func resizeGrid(inputGrid: Crossword, newSize: Int) async throws -> Crossword {
        return try await withCheckedThrowingContinuation { continuation in
            let useCase = ResizeGridUseCase()
            useCase.execute(inputGrid: inputGrid, newSize: newSize) { result in
                switch result {
                    case .success(let resizedGrid):
                        continuation.resume(returning: resizedGrid)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
}
