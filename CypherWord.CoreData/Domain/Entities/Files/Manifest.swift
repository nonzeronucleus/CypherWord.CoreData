

class Manifest {
    var fileDefinitions: [Int:PlayableLevelFileDefinition] = [:]
    
    init(levels:[PlayableLevelFileDefinition]) {
        fileDefinitions = Dictionary(uniqueKeysWithValues: levels.map { level in (level.packNumber!, level) })
    }

//    init(packs:[PackMO]) {
//        fileDefinitions = Dictionary(uniqueKeysWithValues: packs.map { (Int($0.number), PlayableLevelFileDefinition(packMO:$0)) })
//    }

    
    func getLevelFileDefinition(forNumber packNumber:Int) -> PlayableLevelFileDefinition? {
        if let definition = fileDefinitions[packNumber] {
            return definition
        }
        return PlayableLevelFileDefinition(packNumber: packNumber)
    }
    
    var maxLevelNumber:Int {
        return fileDefinitions.keys.max() ?? 0
    }
}
