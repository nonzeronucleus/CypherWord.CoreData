import Foundation

struct Level: Identifiable {
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
    
    var name: String {
        return "Level \(id)"
    }
}
