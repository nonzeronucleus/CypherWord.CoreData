import Foundation
import Dependencies

struct PackDefinition:Identifiable, Equatable, Hashable, Codable {
    var id: UUID
    var packNumber: Int?
    
    init(id:UUID? = nil, packNumber:Int? = nil) {
        @Dependency(\.uuid) var uuid
        if let id = id {
            self.id = id
        }
        else {
            self.id = uuid()
        }
        self.packNumber = packNumber
    }
}
