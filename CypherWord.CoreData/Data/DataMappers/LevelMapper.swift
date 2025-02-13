

class LevelMapper {
    static func map(mo: LevelMO) -> Level? {
        guard let id = mo.id else {
            fatalError("Missing id for LevelMO number \(mo.number)")
        }
        return Level(id: id, number: Int(mo.number), gridText: mo.gridText, letterMap: mo.letterMap, attemptedLetters: mo.attemptedLetters)
    }
    
    static func map(level: Level) -> LevelMO {
        let mo = LevelMO()
        mo.id = level.id
        mo.number = Int64(level.number)
        mo.gridText = level.gridText
        mo.letterMap = level.letterMap
        mo.attemptedLetters = level.attemptedLetters
        return mo
    }
}

