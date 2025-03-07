import Foundation
import Dependencies

protocol FileDefinitionProtocol: Identifiable, Codable, Equatable  {
    func getFileName() -> String
}


class DummyFileDefinition : FileDefinitionProtocol, Codable {
    init() {
        
    }
    
    
    static func == (lhs: DummyFileDefinition, rhs: DummyFileDefinition) -> Bool {
        return true
    }
    
    func getFileName() -> String {
        fatalError("init(from:) has not been implemented")
    }
}


class LayoutFileDefinition : FileDefinitionProtocol, Codable {
    static func == (lhs: LayoutFileDefinition, rhs: LayoutFileDefinition) -> Bool {
        return true
    }
    
    func getFileName() -> String {
        return "Layouts.json"
    }
}

class PlayableLevelFileDefinition : FileDefinitionProtocol {
    static func == (lhs: PlayableLevelFileDefinition, rhs: PlayableLevelFileDefinition) -> Bool {
        return lhs.id == rhs.id
    }
    
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
