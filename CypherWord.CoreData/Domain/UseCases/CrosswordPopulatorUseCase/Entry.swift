import Foundation

class Entry:InstanceEquatable, CustomStringConvertible {
    private(set) var startPos:  Pos
    private(set) var length: Int
    private(set) var direction: Direction
    private(set) var linkedEntries: [Entry] = []
    var word:String?
    
    
    
    init (startPos:Pos, length:Int, direction:Direction) {
        self.startPos = startPos
        self.length = length
        self.direction = direction
    }
    
    convenience init(startPos:Pos, direction:Direction) {
        self.init(startPos:startPos, length:1, direction:direction)
    }
    
    func increaseLength() {
        length += 1
    }
    
    var description: String {
        var str = "Entry: startPos: \(startPos), length: \(length), direction: \(direction)"
        
        for linkedEntry in linkedEntries {
            str += "\n\tlinkedEntry: \(linkedEntry.startPos), \(linkedEntry.direction)"
        }
        
        return str
    }
    
    func isInSamePos(as otherEntry:Entry) -> Bool {
        startPos == otherEntry.startPos && direction == otherEntry.direction && length == otherEntry.length
    }
    
    
    
    func linkEntry(to otherEntry:Entry) {
        linkedEntries.append(otherEntry)
    }
}

