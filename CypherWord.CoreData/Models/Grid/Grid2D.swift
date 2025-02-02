import Foundation
//import Dependencies

protocol Grid2DItem {
    func toStorable() -> Character
    mutating func reset()
}

struct  Grid2D<Element: Codable & Identifiable & Grid2DItem> {
    private(set) var id: UUID
    private(set) var elements: [[Element]]

    var rows: Int {
        get {
            return elements.count
        }
    }
    
    var columns: Int {
        get {
            return elements.first?.count ?? 0
        }
    }

    init(rows: Int, columns: Int, elementGenerator: (Int, Int) -> Element) {
//        @Dependency(\.uuid) var uuid

//        self.id = uuid()
        self.id = UUID()
        self.elements = (0..<rows).map { row in
            (0..<columns).map { column in
                elementGenerator(row, column)
            }
        }
    }
    
    
    subscript(row: Int, column: Int) -> Element {
        get {
            precondition(isValidIndex(row: row, column: column), "Index out of bounds")
            return elements[row][column]
        }
        set {
            precondition(isValidIndex(row: row, column: column), "Index out of bounds")
            elements[row][column] = newValue
        }
    }

    func isValidIndex(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }

    mutating func updateAll(with transform: (Element) -> Element) {
        for row in 0..<rows {
            for column in 0..<columns {
                elements[row][column] = transform(elements[row][column])
            }
        }
    }

    func flatMapGrid<T>(_ transform: (Element) -> T) -> [[T]] {
        return elements.map { $0.map(transform) }
    }
    
    func listElements() -> [Element] {
        return elements.flatMap { $0 }
    }
    
    func getRows() -> [[Element]] {
        return elements
    }
    
    func forEach(_ action: (Element, Int, Int) -> Void) {
        for row in 0..<rows {
            for column in 0..<columns {
                action(elements[row][column], row, column)
            }
        }
    }
    
    func findElement(byID id: Element.ID) -> Element? {
        for row in elements {
            if let element = row.first(where: { $0.id == id }) {
                return element
            }
        }
        return nil
    }
    
    
    func locationOfElement(byID id: Element.ID) -> Pos? {
        for (rowIndex, row) in elements.enumerated() {
            if let columnIndex = row.firstIndex(where: { $0.id == id }) {
                return Pos(row: rowIndex, column: columnIndex)
            }
        }
        return nil
    }
    
    mutating func updateElement(byID id: Element.ID, with transform: (inout Element) -> Void) -> Bool {
        if let location = locationOfElement(byID: id) {
            transform(&elements[location.row][location.column])
            return true
        }
        return false
    }
    
    mutating func updateElement(byPos location: Pos, with transform: (inout Element) -> Void) {
        transform(&elements[location.row][location.column])
    }

    enum CodingKeys: String, CodingKey {
        case grid
    }
}

extension Grid2D {
    func toString() -> String {
        return elements.map { row in
            row.map { "\($0.toStorable())" }.joined(separator: "")
        }.joined(separator: "\n")
    }
}
