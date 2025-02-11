

class LevelMapper {
    static func map(mo: LevelMO) -> Level? {
        guard let id = mo.id else {
            fatalError("Missing id for LevelMO number \(mo.number)")
        }
        return Level(id: id, number: Int(mo.number), gridText: mo.gridText, letterMap: mo.letterMap)
    }
}

