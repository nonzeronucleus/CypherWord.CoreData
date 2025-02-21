extension String {
    // Subscript to get and set characters at a specific index
    subscript(index: Int) -> Character {
        get {
            // Ensure the index is within bounds
            let index = self.index(self.startIndex, offsetBy: index)
            return self[index]
        }
        set(newCharacter) {
//            let stringIndex = self.index(self.startIndex, offsetBy: index)
            var charArray = Array(self)  // Convert string to an array of characters
            charArray[index] = newCharacter  // Modify the character at the specified index
            self = String(charArray)  // Convert the array back to a string
        }
    }
}

