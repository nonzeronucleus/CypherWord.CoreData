import Combine

class LevelFile {
    var definition: (any FileDefinitionProtocol)?
    @Published var levels: [LevelDefinition]
    
    init(definition: (any FileDefinitionProtocol)?, levels: [LevelDefinition]) {
        self.definition = definition
        self.levels = levels
    }
}
