import Foundation


typealias CharacterIntMap = [Character: Int]

extension CharacterIntMap {
    
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

        self = Dictionary(uniqueKeysWithValues: letterValues.map { ($0.key, $0.value) })
    }
    
    
    init(from json: String) {
        if let jsonData = json.data(using: .utf8) {
            if let decodedData = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Int] {
                self = Dictionary(uniqueKeysWithValues: decodedData.map { (Character($0.key), $0.value) })
            }
            else {
                fatalError("Failed to decode JSON \(json)")
            }
        }
        else {
            fatalError("Failed to convert JSON string to data \(json)")
        }
    }
    
    
    // MARK: - Serialize (to JSON)
    func toJSON() -> String {
        let stringKeyedData = self.reduce(into: [String: Int]()) { result, entry in
            result[String(entry.key)] = entry.value
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: stringKeyedData, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return ""
    }
    
    // MARK: - Deserialize (from JSON)
    static func fromJSON(_ json: String) -> CharacterIntMap? {
        guard let data = json.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Int] else {
            return nil
        }
        
        // Convert [String: Int] back to [Character: Int]
        let result = jsonObject.reduce(into: CharacterIntMap()) { result, entry in
            if let character = entry.key.first {
                result[character] = entry.value
            }
        }
        return result
    }
    
    func countCorrectlyPlacedLetters(in attemptedLetters: String) -> Int {
        guard attemptedLetters.count == 26 else {
            print("Error: attemptedLetters must be exactly 26 characters long.")
            return 0
        }
        
        return attemptedLetters.enumerated().filter { index, letter in
            self[letter] == index
        }.count
    }
}
