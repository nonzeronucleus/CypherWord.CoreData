import Foundation

struct CharacterIntMap: Codable {
    //    private var crossword: Crossword?
    private var data: [String: Int]
    
    // Initialize with `[Character: Int]`
    init(_ map: [Character: Int]) {
        self.data = Dictionary(uniqueKeysWithValues: map.map { (String($0.key), $0.value) })
    }
    
    init(shuffle: Bool = false) {
        var letterValues: [Character:Int] = [:]
        
        let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        // Step 2: Shuffle the array to get a random order
        if shuffle {
            let shuffledAlphabet = alphabet.shuffled()
            for (index, letter) in shuffledAlphabet.enumerated() {
                letterValues[letter] = index
            }
        }
        else {
            for (index, letter) in alphabet.enumerated() {
                letterValues[letter] = index
            }
        }
        

        // Step 3: Iterate over each letter and call the function
        
        data = Dictionary(uniqueKeysWithValues: letterValues.map { (String($0.key), $0.value) })
    }
    
    // Convert back to `[Character: Int]`
    var characterIntMap: [Character: Int] {
        Dictionary(uniqueKeysWithValues: data.map { (Character($0.key), $0.value) })
    }
    
    subscript(char:String?) -> Int? {
        get {
            //            precondition(isValidIndex(row: row, column: column), "Index out of bounds")
            if let char {
                if char != " " {
                    return data[char]
                }
            }
            return nil
        }
    }
    
    
    func charFromInt(for value: Int) -> String? {
        return  data.filter { $0.value == value }.map { $0.key }.first
    }
    
    // Subscript to get and set values by Character
    subscript(character: Character) -> Int? {
        get {
            data[String(character)]
        }
        set {
            data[String(character)] = newValue
        }
    }
    
//    subscript(int: Int) -> Character? {
//        get {
//            // Find the key (String) that corresponds to the value (Int).
//            let val = (data.first(where: { $0.value == int })?.key)
//
//            if let val {
//                return Character(val)
//            }
//            return nil
//        }
//        set {
//            // Remove the existing key for the given Int.
//            if let existingKey = data.first(where: { $0.value == int })?.key {
//                data.removeValue(forKey: existingKey)
//            }
//
//            // Add the new key-value pair if `newValue` is not nil.
//            if let newKey = newValue {
//                data[String(newKey)] = int
//            }
//        }
//    }
}
