import Foundation

struct CharacterIntMap: Codable {
    private var data: [String: Int]
    
    init(_ map: [Character: Int]) {
        self.data = Dictionary(uniqueKeysWithValues: map.map { (String($0.key), $0.value) })
    }
    
    init(from json: String) {
        if let jsonData = json.data(using: .utf8) {
            if let decodedData = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Int] {
                data = decodedData
            }
            else {
                fatalError("Failed to decode JSON \(json)")
            }
        }
        else {
            fatalError("Failed to convert JSON string to data \(json)")
        }
    }
    
    init(shuffle: Bool = false) {
        var letterValues: [Character:Int] = [:]
        
        let alphabet = Alphabet
        
        // Shuffle the array to get a random order
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
    
    
    func countCorrectlyPlacedLetters(in attemptedLetters: String) -> Int {
        guard attemptedLetters.count == 26 else {
            print("Error: attemptedLetters must be exactly 26 characters long.")
            return 0
        }
        
        return attemptedLetters.enumerated().filter { index, letter in
            data[String(letter)] == index
        }.count
    }

    
    // Convert back to `[Character: Int]`
    var characterIntMap: [Character: Int] {
        Dictionary(uniqueKeysWithValues: data.map { (Character($0.key), $0.value) })
    }
    
    func toJSON() -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return ""
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
