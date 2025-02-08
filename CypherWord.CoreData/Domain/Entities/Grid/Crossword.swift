typealias Crossword = Grid2D<Cell>

extension Crossword {
    init(rows: Int, columns: Int) {
        self.init(rows: rows, columns: columns, elementGenerator: { row, col in Cell(pos: Pos(row: row, column: col)) })
    }
    
    init(initString:String) {
        let initArray = initString.components(separatedBy: "|").filter { !$0.isEmpty }
        
        let rows = initArray.count
        let columns = initArray[0].count
        
        self.init(rows: rows, columns: columns) {
            row, col in
                return Cell(pos: Pos(row: row, column: col), configChar: initArray[row][col])
        }
    }
    
    
    mutating func reset() {
        for rowIndex in elements.indices {
            for colIndex in elements[rowIndex].indices {
                var elem = elements[rowIndex][colIndex]
                elem.reset()
                self[rowIndex,colIndex] = elem
            }
        }
    }
    
    var isPopulated: Bool {
        for element in self.listElements() {
            if element.letter == " " {
                return false
            }
        }
        return true
    }
}
