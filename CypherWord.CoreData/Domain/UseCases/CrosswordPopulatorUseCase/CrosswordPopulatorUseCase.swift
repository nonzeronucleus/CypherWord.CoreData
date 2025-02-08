import Foundation

class CrosswordPopulatorUseCase {
    let wordlist = WordListContainer()
    private(set) var entries: [Entry] = []
    private var crossword:Crossword
    
    var alphabetByFrequency = "JQZXFVWBKHMYPCUGILNORSTADE"
    var letters:[Character] = []
    
    init(crossword:Crossword) {
        self.crossword = crossword
        entries = findEntries(in: crossword)
        reset()
    }
    
    func contains(entry:Entry) -> Bool {
        for existingEntry in entries {
            if existingEntry.isInSamePos(as:entry){
                return true
            }
        }
        return false
    }

    func reset() {
        crossword.reset()
    }

    func resetLetters() {
        letters.removeAll()
        
        for char in alphabetByFrequency {
            letters.append(char)
        }
    }

    func populateCrossword() -> (crossword:Crossword, characterIntMap:CharacterIntMap) {
        let entryTree = EntryTree.init(rootEntry: entries.randomElement()!)
        var populated = false

        while !populated {
            if populateNode(node: entryTree.root) {
                populated = true
            }
            else {
                entryTree.resetCount()
                reset()
            }
        }
        
        return (crossword:crossword, characterIntMap:CharacterIntMap())
    }

    private func populateNode(node:EntryNode) -> Bool{
        var attempts = 0
        var childrenPopulated = false
        let mask = getWord(entry: node.entry)
        
        while !childrenPopulated {
            node.increaseCount()
            
            if (node.getCount() > 100) {
                return false
            }
            
            childrenPopulated = true
            upateLettersWithFoundWords()
            
            let wordsByLength = wordlist.getWordsByLength(length: mask.count)
            
            let matchingWords = wordsByLength.filterByMask(mask: mask)
            var finalWordList: [String] = []
            var tempLetters = letters
            
            while finalWordList.count == 0 && tempLetters.count > 0 {
                let letter = tempLetters.removeFirst()
                finalWordList = matchingWords.filterContaining(letter: letter)
            }
            
            if finalWordList.count == 0 {
                finalWordList = matchingWords
            }
            
            if let word = finalWordList.randomElement() {
                setWord(entry: node.entry, word: word)
                for child in node.children {
                    childrenPopulated = childrenPopulated && populateNode(node: child)
                }
                
                if !childrenPopulated {
                    setWord(entry: node.entry, word: mask)
                    if attempts > 2 {
                        return false
                    }
                    attempts += 1
                }
            }
            else {
                return false
            }
        }
        return true
    }
    
    private func getWord(entry:Entry) -> String {
        var word = ""
        if entry.length == 0 {
            return ""
        }

        let iter = entry.direction == .across ? (0,1) : (1,0)

        for i in 0...entry.length-1 {
            let pos = Pos(row:entry.startPos.row + iter.0 * i, column: entry.startPos.column + iter.1 * i)
            let cell = crossword[pos.row, pos.column]

            if let char = cell.letter {
                word.append(char)
            }
        }

        return word
    }

    func setWord(entry:Entry, word:String) {
        if entry.length == 0 {
            return
        }
        
        guard word.count == entry.length else { return }
        
        let iter = entry.direction == .across ? (0,1) : (1,0)
        
        for i in 0...entry.length-1 {
            let index = word.index(word.startIndex, offsetBy: i)
            let char = word[index]
            crossword[entry.startPos.row + iter.0 * i, entry.startPos.column + iter.1 * i].letter = char
        }
    }
    
    func upateLettersWithFoundWords() {
        resetLetters()
        for cell in crossword.listElements() {
            if cell.letter != nil {
                removeLetter(letter: cell.letter!)
            }
        }
    }
    
    func removeLetter(letter: Character) {
        if let index = letters.firstIndex(of: letter) {
            letters.remove(at: index)
        }
    }
}



