//
//  EntryNode.swift
//  CodeWord
//
//  Created by Ian Plumb on 01/11/2024.
//


class EntryNode {
    let entry: Entry
    var children: [EntryNode]
    var tree: EntryTree?
    
    init(entry: Entry) {
        self.entry = entry
        self.children = []
    }
    
    func addChild(_ child: EntryNode) {
        children.append(child)
    }
    
    func findNode(_ entry: Entry) -> EntryNode? {
        for child in children {
            if child.entry == entry {
                return child
            }
            if let found = child.findNode(entry) {
                return found
            }
        }
        return nil
    }
    
    func getCount() -> Int {
        if let tree = tree {
            return tree.count
        }
        return 0
    }
    
//    func printNode() {
//        print(entry.getWord())
//        for child in children {
//            child.printNode()
//
//        }
//    }
    
    func increaseCount() {
        if let tree = tree {
            tree.increaseCount()
        }
    }
}
