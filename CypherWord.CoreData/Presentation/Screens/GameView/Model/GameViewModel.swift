import Foundation
import Dependencies



class GameViewModel: ObservableObject {
    @Dependency(\.fetchLevelByIDUseCase) private var fetchLevelByIDUseCase: FetchLevelByIDUseCaseProtocol
    @Dependency(\.saveLevelUseCase) private var saveLevelUseCase: SaveLevelUseCaseProtocol

    @Published private(set) var error:String?
    
    @Published private(set) var levelDefinition: LevelDefinition
    @Published private(set) var level: Level
//    @Published var letterValues: CharacterIntMap?
//    @Published var attemptedValues: [Character] = []
//    @Published var crossword: Crossword?
 
    @Published var selectedNumber: Int?
    
    @Published var isBusy: Bool = false
    @Published var showingConfirmation: Bool = false
    @Published var completed: Bool = false
    @Published var checking: Bool = false
    @Published var numCorrectLetters: Int = 0
    @Published var showCompletedDialog: Bool = false
    
    private let navigationViewModel: NavigationViewModel?
    
    
    init(level:LevelDefinition, navigationViewModel:NavigationViewModel? = nil) {
        self.levelDefinition = level
        self.level = Level(definition: level)
        self.navigationViewModel = navigationViewModel
        
        let transformer = CrosswordTransformer()
        
        guard let gridText = level.gridText else {
            error = "Could not load crossword grid"
            return
        }
//        crossword = transformer.reverseTransformedValue(gridText) as? Crossword
//        
//        if let letterValuesText = level.letterMap
//        {
//            let letterValues = CharacterIntMap(from: letterValuesText)
//            self.letterValues = letterValues
//        }
//        
//        attemptedValues = Array(level.attemptedLetters)
        
        numCorrectLetters = level.numCorrectLetters
        
        
        
        revealLetter(letter: "X")
        revealLetter(letter: "Z")
        
//        print(level.letterMap) // TODO
    }
    
    
    func revealLetter(letter:Character) {
        let val = level.letterMap![letter]
        
        if let val {
            setAttemptedValue(idx: val, char: letter)
        }
    }
    
    func onCellClick(id:UUID) {
//        guard let crossword = level.crossword else {
//            error = "Could not find crossword grid"
//            return
//        }
        
        if completed {
            return
        }
        
        checking = false
        
        let cell = level.crossword.findElement(byID: id)
        
        if let cell = cell {
            if let letter = cell.letter {
                if let number = level.letterMap?[letter] {
                    selectedNumber = number
                }
            }
        }
    }
    
    
    func onLetterPressed(letter: Character) {
        if completed {
            return
        }

        checking = false
        if let selectedNumber {
            setAttemptedValue(idx: selectedNumber, char: letter)
        }
    }
    
    
    func save(then onComplete: @escaping (() -> Void) = {}) {
        isBusy = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
//            levelDefinition.attemptedLetters = String(self.attemptedValues)
            levelDefinition = LevelDefinition(from: level)
            saveProgress()
        }
    }

    
    private func saveProgress() {
        saveLevelUseCase.execute(level: levelDefinition, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success():
                        self?.isBusy = false
                    case .failure(let error):
                        self?.error = error.localizedDescription
                }
            }
        })
    }
    
    
    func onDeletePressed() {
        if completed {
            return
        }

        checking = false
        if let selectedNumber {
            setAttemptedValue(idx: selectedNumber, char: " ")
        }
    }
    
    func setAttemptedValue(idx: Int, char:Character) {
        let prevNumCorrectLetters = level.numCorrectLetters
        level.attemptedLetters[idx] = char
//        levelDefinition.attemptedLetters = String(attemptedValues)
//        numCorrectLetters = levelDefinition.numCorrectLetters
        if prevNumCorrectLetters < 26 && level.numCorrectLetters == 26 {
            showCompletedDialog = true
        }
        save()
    }
    
    func checkLetters() {
        checking.toggle()
    }
    
    func revealLetter() {
        guard let letterMap = level.letterMap else {
            return
        }
        
        for mappedLetter in letterMap.characterIntMap {
            if !usedLetters.contains(mappedLetter.key) {
                revealLetter(letter: mappedLetter.key)
                return
            }
        }
    }
    
    var usedLetters: Set<Character> {
        Set(level.attemptedLetters.filter { $0 != " " })
    }
    
    func handleBackButtonTap() {
        if let navigationViewModel {
            navigationViewModel.goBack()
        }
    }
    
    func exit() {
        showingConfirmation = false
    }
}
