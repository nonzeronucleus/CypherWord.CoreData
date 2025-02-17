import CoreData

class LevelMapper {
    static func map(mo: LevelMO) -> LevelDefinition {
        guard let id = mo.id else {
            fatalError("Missing id for LevelMO number \(mo.number)")
        }
        return LevelDefinition(id: id,
                               number: Int(mo.number),
                               gridText: mo.gridText,
                               letterMap: mo.letterMap,
                               attemptedLetters: mo.attemptedLetters,
                               numCorrectLetters: Int(mo.numCorrectLetters)
        )
    }
    
    static func map(context:NSManagedObjectContext, level: LevelDefinition, getNextNum: () throws -> Int64) throws -> LevelMO {
        let mo = LevelMO(context: context)
        mo.id = level.id
        
        if let number = level.number {
            mo.number = Int64(number)
        }
        else {
            try mo.number = getNextNum()
        }
        
        mo.gridText = level.gridText
        mo.letterMap = level.letterMap
        mo.attemptedLetters = level.attemptedLetters
        mo.numCorrectLetters = Int16(level.numCorrectLetters)
        return mo
    }
}

