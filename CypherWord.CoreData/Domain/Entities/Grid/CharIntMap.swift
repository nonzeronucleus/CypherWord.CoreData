import Foundation

struct CharacterIntMap: Codable {
    private var data: [String: Int]
    
    init(_ map: [Character: Int]) {
        self.data = Dictionary(uniqueKeysWithValues: map.map { (String($0.key), $0.value) })
    }
    
    init(shuffle: Bool = false) {
        var letterValues: [Character:Int] = [:]
        
        let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        // SShuffle the array to get a random order
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
        

        // Iterate over each letter and call the function
        
        data = Dictionary(uniqueKeysWithValues: letterValues.map { (String($0.key), $0.value) })
    }
    
    // Convert back to `[Character: Int]`
    var characterIntMap: [Character: Int] {
        Dictionary(uniqueKeysWithValues: data.map { (Character($0.key), $0.value) })
    }
    
    subscript(char:String?) -> Int? {
        get {
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
}
