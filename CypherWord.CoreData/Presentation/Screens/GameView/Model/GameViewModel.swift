import Foundation
import Dependencies



class GameViewModel: ObservableObject {
    @Dependency(\.fetchLevelByIDUseCase) private var fetchLevelByIDUseCase: FetchLevelByIDUseCaseProtocol
    @Dependency(\.saveLevelUseCase) private var saveLevelUseCase: SaveLevelUseCaseProtocol

    @Published private(set) var error:String?
    
    @Published private(set) var level: Level
    @Published var letterValues: CharacterIntMap?
    @Published var attemptedValues: [Character] = []
    @Published var crossword: Crossword?
 
    @Published var selectedNumber: Int?
    
    @Published var isBusy: Bool = false
    @Published var showingConfirmation: Bool = false
    @Published var completed: Bool = false
    @Published var checking: Bool = false
    private let navigationViewModel: NavigationViewModel?
    
    
    init(level:Level, navigationViewModel:NavigationViewModel? = nil) {
        self.level = level
        self.navigationViewModel = navigationViewModel
        
        let transformer = CrosswordTransformer()
        
        guard let gridText = level.gridText else {
            error = "Could not load crossword grid"
            return
        }
        crossword = transformer.reverseTransformedValue(gridText) as? Crossword
        
        if let letterValuesText = level.letterMap
        {
            let letterValues = CharacterIntMap(from: letterValuesText)
            self.letterValues = letterValues
        }
        
        attemptedValues = Array(level.attemptedLetters)
        
        revealLetter(letter: "X")
        revealLetter(letter: "Z")
    }
    
    
    func revealLetter(letter:Character) {
        let val = letterValues![letter]
        
        if let val {
            attemptedValues[val] = letter
        }
    }
    
    func onCellClick(id:UUID) {
        guard let crossword else {
            error = "Could not find crossword grid"
            return
        }
        
        if completed {
            return
        }
        
        checking = false
        
        let cell = crossword.findElement(byID: id)
        
        if let cell = cell {
            if let letter = cell.letter {
                if let number = letterValues?[letter] {
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
            attemptedValues[selectedNumber] = letter
            save()
        }
    }
    
    
    func save(then onComplete: @escaping (() -> Void) = {}) {
        isBusy = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            level.attemptedLetters = String(self.attemptedValues)
            saveProgress()
        }
    }

    
    private func saveProgress() {
        saveLevelUseCase.execute(level: level, completion: { [weak self] result in
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
            attemptedValues[selectedNumber] = " "
            save()
        }
    }
    
    func checkLetters() {
        checking.toggle()
    }
    
    func revealLetter() {
        if let letterValues {
            for mappedLetter in letterValues.characterIntMap {
                if !usedLetters.contains(mappedLetter.key) {
                    revealLetter(letter: mappedLetter.key)
                    return
                }
            }
        }
    }
    
    var usedLetters: Set<Character> {
        Set(attemptedValues.filter { $0 != " " })
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
