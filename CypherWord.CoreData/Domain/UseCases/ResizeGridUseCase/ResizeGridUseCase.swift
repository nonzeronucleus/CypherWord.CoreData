class ResizeGridUseCase : ResizeGridUseCaseProtocol {
    func execute(inputGrid: Crossword, newSize:Int, completion: @escaping (Result<Crossword, any Error>) -> Void) {
        let size = inputGrid.rows
        let growthSize = newSize - size
        let offset = abs(growthSize / 2)

        // Create a new grid with default cells
        var newGrid = Crossword(rows: newSize, columns: newSize)
        
        // Determine bounds for copying elements
        let minSize = min(size, newSize)
        let rowOffset = growthSize > 0 ? offset : 0
        let columnOffset = growthSize > 0 ? offset : 0

            // Copy existing cells into their new positions
        for row in 0..<minSize {
            for column in 0..<minSize {
                let sourceRow = row + (growthSize < 0 ? offset : 0)
                let sourceColumn = column + (growthSize < 0 ? offset : 0)
                let targetRow = row + rowOffset
                let targetColumn = column + columnOffset
                newGrid[targetRow, targetColumn] = inputGrid[sourceRow, sourceColumn]
            }
        }

        completion(.success(newGrid))
    }
}
