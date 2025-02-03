import Foundation


class EntryTracker {
    var entries: [Entry] = []
    var currentEntry: Entry?
    
    func trackOpenCell(at pos: Pos, direction:Direction) {
        if currentEntry == nil {
            let newEntry = Entry(startPos: pos, direction: direction)
            currentEntry = newEntry
        }
        else {
            currentEntry!.increaseLength()
        }
    }
    
    func trackClosedCell() {
        if let currentEntry = currentEntry {
            if currentEntry.length > 1 {
                entries.append(currentEntry)
                for entry in entries {
                    checkOverlap(with: entry)
                }
            }
        }
        
        currentEntry = nil
    }
    
    
    // Check to see if any other entries share cells with this one
    func checkOverlap(with otherEntry:Entry) {
        if let currentEntry = currentEntry {
            guard (currentEntry.direction != otherEntry.direction) else { return }
            
            let horiz = currentEntry.direction == .across ? currentEntry : otherEntry
            let vert = currentEntry.direction == .down ? currentEntry : otherEntry
            let horizStart = horiz.startPos
            let vertStart = vert.startPos
            
            // There's an overlap
            if (horizStart.column...horizStart.column+horiz.length-1).contains(vertStart.column) && (vertStart.row...vertStart.row+vert.length-1).contains(horizStart.row) {
                currentEntry.linkEntry(to: otherEntry)
                otherEntry.linkEntry(to: currentEntry)
            }
        }
    }
}





func findEntries(in crossword: Crossword) -> [Entry] {
    let entryTracker = EntryTracker()
    
    // Find all across clues
    for row in 0..<crossword.rows {
        for col in 0..<crossword.columns {
            let cell = crossword[row,col]
            
            if cell.isActive {
                entryTracker.trackOpenCell(at: cell.pos, direction: .across)
            }
            else {
                entryTracker.trackClosedCell()
            }
        }
            
        entryTracker.trackClosedCell()
    }
    
    // Find all down clues
    for col in 0...crossword.columns-1 {
        for row in 0...crossword.rows-1 {
            let cell = crossword[row,col]
            
            if cell.isActive {
                entryTracker.trackOpenCell(at: cell.pos, direction: .down)
            }
            else {
                entryTracker.trackClosedCell()
            }
        }
        entryTracker.trackClosedCell()
    }
    
    let entries = entryTracker.entries
    
    return entries
}
