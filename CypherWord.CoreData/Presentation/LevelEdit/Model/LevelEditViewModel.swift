import Foundation
//import Dependencies




class LevelEditViewModel: ObservableObject {
    static let defaultSize = 11
    @Published private(set) var level: Level
    @Published var size: Int
    @Published var crossword: Crossword
    @Published private(set) var error:String?
    @Published var letterValues: CharacterIntMap?
    @Published var isPopulated: Bool = false
    
    init(level:Level) {
        self.level = level
        var newCrossword:Crossword?
        
        let transformer = CrosswordTransformer()
        
        if let gridText = level.gridText {
            newCrossword = transformer.reverseTransformedValue(gridText) as? Crossword
        }
        if newCrossword == nil {
            newCrossword = Crossword(rows: 15, columns: 15)
        }
        
        crossword = newCrossword!
        
        size = newCrossword!.columns
    }
    
    func toggleCell(id: UUID) {
        if let location = crossword.locationOfElement(byID: id) {
            crossword.updateElement(byPos: location) { cell in
                cell.toggle()
            }
            let opposite = Pos(row: crossword.columns - 1 - location.row, column: crossword.rows - 1 - location.column)
            
            if opposite != location {
                crossword.updateElement(byPos: opposite) { cell in
                    cell.toggle()
                }
            }
        }
    }
    
    func save() {
//        let levelDataService = LevelDataService.shared
//        let transformer = CrosswordTransformer()
//        
//        let gridText = transformer.transformedValue(crossword) as? String
//        
//        if let gridText = gridText {
//            level.gridText = gridText
//            levelDataService.updateLevel(level:level)
//        }
    }
    
    func generate() {
//        let populator = CrosswordPopulatorService(crossword: crossword)
//        
//        let populated = populator.populateCrossword()
//        
//        crossword = populated.crossword
//        
//        letterValues = populated.characterIntMap
//        isPopulated = true
    }
    
    func resize(newSize: Int) {
        guard size != newSize else { return }

//        let resizer = Resizer(newSize: newSize)

        size = newSize
//        crossword = resizer.perform(inputGrid: crossword)
    }
}

    
    // Create new level
//    init(initSize:Int = LevelEditViewModel.defaultSize) {
//        size = initSize
//        
////        @Dependency(\.uuid) var uuid
//        self.level = LevelDefinition(id: UUID(), fileType: .layout, levelNumber: LevelNumberTracker.inst.getNextLevelNumber())
//        
//        crossword = Crossword(rows: initSize, columns: initSize)
//    }
//    
//    init(level: LevelDefinition, crossword: Crossword) {
//        self.level = level
//        self.crossword = crossword
//        self.size = crossword.rows
//    }
//    
//    init(levelData: LevelData) {
//        level = levelData.level
//        crossword = levelData.crossword
//        size = levelData.crossword.rows
//        letterValues = levelData.letterValues
//    }
//    
//    init(level: LevelDefinition, error: String) {
//        self.error = error
//        self.level = level
//        
//        let size = LevelEditViewModel.defaultSize
//        
//        self.size = size
//        self.crossword = Crossword(rows: size, columns: size)
//    }
//    
//    static func loadFrom(newLevel: LevelDefinition)  -> LevelEditViewModel {
//        @Dependency(\.levelDataMgr) var levelDataMgr
//
//        do {
//            let levelData = try levelDataMgr.load(level: newLevel)
//            return LevelEditViewModel(levelData:levelData)
//        } catch {
//            return LevelEditViewModel(level:newLevel, error: error.localizedDescription)
//        }
//    }
//    
//    func save() {
//        @Dependency(\.levelDataMgr) var levelDataMgr
//        let levelData = LevelData(level: level, crossword: crossword,letterValues: letterValues/*, attemptedletterValues: []*/)
//        
//        do {
//            try levelDataMgr.save(levelData: levelData)
//        } catch {
//            self.error = error.localizedDescription
//        }
//    }
//
//
//    func resize(newSize: Int) {
//        guard size != newSize else { return }
//        
//        let resizer = Resizer(newSize: newSize)
//        
//        size = newSize
//        crossword = resizer.perform(inputGrid: crossword)
//    }
//    
//    func populate() {
//        let populator = CrosswordPopulator(crossword: crossword)
//        
//        let populated = populator.populateCrossword()
//        
//        crossword = populated.crossword
//        
//        letterValues = populated.characterIntMap//CharacterIntMap(populated.characterIntMap)
//    }
//    
//    func reset() {
//        crossword.reset()
//    }
//
//    var name: String {
//        return String(level.id.uuidString.prefix(8))
//    }
//    
//    func dismissError() {
//        error = nil
//    }
//    
//    func getID(fromPos pos:Pos) -> UUID {
//        return crossword[pos.row, pos.column].id
//    }
//    
//}
