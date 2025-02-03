import Foundation

struct Level: Identifiable, Codable {
    var id: UUID
    var number: Int
    var gridText: String?
    var letterMap: String?
    var levelType: LevelType {
        get {
            return letterMap == nil ? .layout : .playable
        }
    }

    enum LevelType: String, Codable {
        case layout = "layout"
        case playable = "playable"
    }

    init(id: UUID, number: Int, gridText: String?, letterMap: String?) {
        self.id = id
        self.number = number
        self.gridText = gridText
        self.letterMap = letterMap
    }

    var name: String {
        return "Level \(number), \(levelType)"
    }

    func toLevelMO() -> LevelMO {
        let model = LevelMO()
        model.id = id
        model.number = Int64(number)
        model.gridText = gridText
        model.letterMap = letterMap
        return model
    }
}
