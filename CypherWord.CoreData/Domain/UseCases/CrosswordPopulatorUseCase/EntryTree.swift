class EntryTree {
    var root: EntryNode
    var count: Int = 0
    
    init(rootEntry: Entry) {
        self.root = EntryNode(entry: rootEntry)
        root.tree = self
        addChildren(parent: root)
    }
    
    func resetCount() {
        count = 0
    }
    
    func increaseCount() {
        count += 1
    }
    
    func addChildren(parent: EntryNode) {
        for childEntry in parent.entry.linkedEntries {
            if findNode(childEntry) == nil {
                let child = EntryNode(entry: childEntry)
                child.tree = self
                
                parent.children.append(child)
                addChildren(parent: child)
            }
        }
    }
    
    func findNode(_ entry: Entry) -> EntryNode? {
        return root.findNode(entry)
    }
}
