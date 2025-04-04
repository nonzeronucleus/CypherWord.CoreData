import Foundation
import Dependencies

protocol FileDefinitionProtocol: Identifiable, Codable, Equatable  {
    func getFileName() -> String
}


class DummyFileDefinition : FileDefinitionProtocol, Codable {
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
    let packDefinition: PackDefinition
    var id:UUID {
        get {
            return packDefinition.id
        }
    }
    
    var packNumber:Int? {
        get {
            return packDefinition.packNumber
        }
    }
    
    static func == (lhs: PlayableLevelFileDefinition, rhs: PlayableLevelFileDefinition) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(packMO:PackMO) {
        guard let id = packMO.id else {
            fatalError("Missing id for packMO \(packMO)")
        }
        let packNumber  = Int(packMO.number)
        packDefinition = PackDefinition(id: id, packNumber: packNumber)
    }
    
    init(packDefintion: PackDefinition) {
        self.packDefinition = packDefintion
    }
    

    
    init(packNumber: Int?, id: UUID? = nil) {
        var id = id
        
        if id == nil {
            @Dependency(\.uuid) var uuid
            id = uuid()
        }
        packDefinition = PackDefinition(id: id, packNumber: packNumber)
    }
    
    func getFileName() -> String {
        guard let packNumber = packDefinition.packNumber else {
            fatalError(#function)
        }
        return "Games.\(packNumber).json"
    }
    
    var manifestFileName:String = "Manifest.json"
}
