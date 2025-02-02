import Foundation

extension Array where Element == String {
    func filterByMask(mask: String) -> [String] {
        let maskLength = mask.count
        
        return self.filter { word in
            guard word.count == maskLength else { return false }  // Length must match mask
            for (wordChar, maskChar) in zip(word, mask) {
                if maskChar != " " && maskChar != wordChar {
                    return false  // Character doesn't match the mask
                }
            }
            return true  // All characters match the mask
        }
    }


    func filterContaining(letter: Character) -> [String] {
        return self.filter { $0.contains(letter) }
    }
    
    func filterByLength(length: Int) -> [String] {
        return self.filter { $0.count == length }
    }
}
