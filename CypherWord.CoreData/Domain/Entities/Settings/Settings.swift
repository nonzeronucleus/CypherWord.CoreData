import Combine
import Foundation

struct Settings: Codable, Equatable {
    var showCompletedLevels: Bool 
    var editMode: Bool = false
    
    init(showCompletedLevels: Bool = false, editMode: Bool = false) {
        self.showCompletedLevels = showCompletedLevels
        self.editMode = editMode
    }
}
