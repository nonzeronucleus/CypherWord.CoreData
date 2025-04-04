import Combine

class LevelFile {
    var definition: (any FileDefinitionProtocol)?
    @Published var levels: [LevelDefinition]
    
    init(definition: (any FileDefinitionProtocol)?, levels: [LevelDefinition]) {
        guard let definition = definition else {
            self.definition = nil
            self.levels = levels
            return
        }
        
        self.definition = definition
        self.levels = levels
    }
}
