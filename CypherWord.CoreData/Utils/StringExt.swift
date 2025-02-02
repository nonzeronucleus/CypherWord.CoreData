extension String {
    subscript(index: Int) -> Character {
        get {
            precondition(index >= 0 && index < count, "Index out of bounds")
            return self[self.index(self.startIndex, offsetBy: index)]
        }
    }
}
