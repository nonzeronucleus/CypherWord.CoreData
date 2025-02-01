import Foundation

struct Level: Identifiable, Codable {
    var id: UUID
    var number:Int
    var gridText:String?
    var letterMap: String?
    
    init(id: UUID, number:Int, gridText:String, letterMap: String) {
        self.id = id
        self.number = number
        self.gridText = gridText
        self.letterMap = letterMap
    }
    
    var name: String {
        return "Level \(number)"
    }
    
    func toLevelMO() -> LevelMO {
        let model = LevelMO()
        model.id = id
        model.number = Int64(number)
        model.gridText = gridText ?? ""
        model.letterMap = letterMap ?? ""
        return model
    }
}
