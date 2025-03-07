import Foundation
import Dependencies

protocol FileDefinitionProtocol {
    func getFileName() -> String
}

class LayoutFileDefinition : FileDefinitionProtocol {
    func getFileName() -> String {
        return "Layouts.json"
    }
}

class PlayableLevelFileDefinition : FileDefinitionProtocol {
    let packNumber: Int
    let id: UUID
    
    init(packNumber: Int, id: UUID? = nil) {
        if let id = id {
            self.id = id
        } else {
            @Dependency(\.uuid) var uuid
            self.id = uuid()
        }
        self.packNumber = packNumber
    }
    
    func getFileName() -> String {
        "Games.\(packNumber).json"
    }
    
    var manifestFileName:String = "Manifest.json"
}
