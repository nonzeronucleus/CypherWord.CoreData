protocol FileDefinitionProtocol {
    func getFileName() -> String
}

class LayoutFileDefinition : FileDefinitionProtocol {
    init() {
    }
    
    func getFileName() -> String {
        return "Layouts.json"
    }
}

class PlayableLevelFileDefinition : FileDefinitionProtocol {
    let packNumber: Int
    
    init(packNumber: Int) {
        self.packNumber = packNumber
    }
    
    func getFileName() -> String {
        "Games.\(packNumber).json"
    }
}
