import Foundation

class WordListContainer : WordListContainerProtocol {
    let words: [String]
    var wordsByLength: [Int:[String]]
    var count:Int { words.count }
    
    init() {
        let name = "ukenglish"
        self.words = WordListContainer.loadFile(name)
        self.wordsByLength = WordListContainer.groupWordsByLength(words: words)
    }
    
    func getWordsByLength(length:Int) -> [String] {
        let words = wordsByLength[length] ?? []
        return words
    }
    
    static func groupWordsByLength(words: [String]) -> [Int:[String]] {
        var wordsByLength: [Int:[String]] = [:]
        
        for word in words {
            var matchingWords = wordsByLength[word.count] ?? []
            
            matchingWords.append(word)
            wordsByLength[word.count] = matchingWords
        }
        return wordsByLength
    }
    
    static private func loadFile(_ name:String) -> [String] {
        guard let file = Bundle.main.url(forResource: name, withExtension: "txt")
        else {
            fatalError("Failed file")
        }
        do {
            let data = try String(contentsOfFile:file.path, encoding: String.Encoding.ascii)
            return data.components(separatedBy: "\n")
        }
        catch let err as NSError {
            fatalError(err.description)
        }
    }
}
