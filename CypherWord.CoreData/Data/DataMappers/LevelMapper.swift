import CoreData

class LevelMapper {
    static func toLevelDefinition(mo: LevelMO) -> LevelDefinition {
        guard let id = mo.id else {
            fatalError("Missing id for LevelMO number \(mo.number)")
        }
        
        return LevelDefinition(id: id, //fileDefinition: DummyFileDefinition(),
                               number: Int(mo.number),
                               packId: mo.packId,
                               gridText: mo.gridText,
                               letterMap: mo.letterMap,
                               attemptedLetters: mo.attemptedLetters,
                               numCorrectLetters: Int(mo.numCorrectLetters)
        )
    }
    
    static func toLevelMO(context:NSManagedObjectContext, levelDefinition: LevelDefinition, getNextNum: () throws -> Int64) throws -> LevelMO {
        var mo = LevelMO(context: context)
        mo.id = levelDefinition.id
        
        if let number = levelDefinition.number {
            mo.number = Int64(number)
        }
        else {
            try mo.number = getNextNum()
        }
        
        toLevelMO(from: levelDefinition, to: &mo)
        
        return mo
    }
    
    static func toLevelMO(from levelDefinition: LevelDefinition, to mo: inout LevelMO )  {
        mo.gridText = levelDefinition.gridText
        mo.letterMap = levelDefinition.letterMap
        mo.attemptedLetters = levelDefinition.attemptedLetters
        mo.numCorrectLetters = Int16(levelDefinition.numCorrectLetters)
    }
}

