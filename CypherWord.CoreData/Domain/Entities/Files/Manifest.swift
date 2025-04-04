

class Manifest {
    var fileDefinitions: [Int:PackDefinition] = [:]
    
    init(levels:[PackDefinition]) {
        fileDefinitions = Dictionary(uniqueKeysWithValues: levels.map { level in (level.packNumber!, level) })
    }
    
    func getLevelFileDefinition(forNumber packNumber:Int) -> PackDefinition? {
        if let definition = fileDefinitions[packNumber] {
            return definition
        }
        return PackDefinition(packNumber: packNumber)
    }
    
    var maxLevelNumber:Int {
        return fileDefinitions.keys.max() ?? 0
    }
    
    func getNextPack(currentPack: PackDefinition) -> PackDefinition? {
        guard let currentPackNumber = currentPack.packNumber else { return nil }
        let nextPackNumber = currentPackNumber + 1
        return getLevelFileDefinition(forNumber: nextPackNumber)
    }
    
    func getPreviousPack(currentPack: PackDefinition) -> PackDefinition? {
        guard let currentPackNumber = currentPack.packNumber else { return nil }
        let nextPackNumber = currentPackNumber - 1
        return getLevelFileDefinition(forNumber: nextPackNumber)
    }
}
