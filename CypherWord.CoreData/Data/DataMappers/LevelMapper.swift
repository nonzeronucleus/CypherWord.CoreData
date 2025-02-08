

class LevelMapper {
    static func map(mo: LevelMO) -> Level {
        guard let id = mo.id else {
            fatalError("Missing id for LevelMO number \(mo.number)")
        }
        return Level(id: id, number: Int(mo.number), gridText: mo.gridText, letterMap: mo.letterMap)
    }
}

//    func getLevels() -> [Level]
//    func addLevel(_ level: Level) -> [Level]
//    func deleteLevel(_ Level: Level) -> [Level]


//
//class LevelRepositoryImpl: LevelRepository {
//    private var levels: [Level] = []
//    var levelType: Level.LevelType
//    
//    init(type: Level.LevelType) {
//        self.levelType = type
//        
//        loadLevels()
//    }
//    
//    func loadLevels() {
//        
//    }
//    
//    
//    func getLevels() -> [Level] {
//        return levels
//    }
//    
//    func addLevel(_ level: Level) -> [Level] {
//        levels.append(level)
//        return levels
//    }
//    
//    func deleteLevel(_ Level: Level) -> [Level] {
//        return levels
//    }
//}
