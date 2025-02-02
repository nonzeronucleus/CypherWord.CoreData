struct Pos:Equatable, Hashable, Codable {
    let row:Int
    let column:Int
    
    static var nilPos:Pos { .init(row: -1, column: -1) }
    
    static func / (lhs:Pos, rhs:Int) -> Pos {
        return Pos(row: lhs.row / rhs, column: lhs.column / rhs)
    }
}
