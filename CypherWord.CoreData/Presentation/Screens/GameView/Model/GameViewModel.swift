import Foundation
import Dependencies

class GameViewModel: ObservableObject {
    private var saveLevelUseCase: SaveLevelUseCaseProtocol

    @Published private(set) var error:String?
    
    @Published private(set) var levelDefinition: LevelDefinition
    @Published private(set) var level: Level
 
    @Published var selectedNumber: Int?
    
    @Published var isBusy: Bool = false
    @Published var showingConfirmation: Bool = false
    @Published var completed: Bool = false
    @Published var checking: Bool = false
    @Published var showCompletedDialog: Bool = false
    @Published var numCorrectLetters: Int = 0
    
    private let navigationViewModel: NavigationViewModel?
    
    
    init(level:LevelDefinition,
         navigationViewModel:NavigationViewModel? = nil,
         saveLevelUseCase: SaveLevelUseCaseProtocol = SaveLevelUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue)
    ) {
        self.saveLevelUseCase = saveLevelUseCase
        self.levelDefinition = level
        self.level = Level(definition: level)
        self.navigationViewModel = navigationViewModel
        
        revealLetter(letter: "X")
        revealLetter(letter: "Z")
    }
    
    
    func revealLetter(letter:Character) {
        let val = level.letterMap![letter]
        
        if let val {
            setAttemptedValue(idx: val, char: letter)
        }
    }
    
    func onCellClick(id:UUID) {
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
    
    
//    func save(then onComplete: @escaping (() -> Void) = {}) {
//        isBusy = true
//        
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            levelDefinition = LevelDefinition(from: level)
//            saveProgress()
//        }
//    }
    
    func save() {
        isBusy = true
        
        Task {
            try! await saveProgress()
            isBusy = false
        }
        
    }
//

    
    private func saveProgress() async throws {
        try await saveLevelUseCase.execute(level: levelDefinition)
        isBusy = false
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
        if prevNumCorrectLetters < 26 && level.numCorrectLetters == 26 {
            showCompletedDialog = true
        }
        numCorrectLetters = level.numCorrectLetters
        save()
    }
    
    func checkLetters() {
        checking.toggle()
    }
    
    func revealNextLetter() {
        if let letter = level.getNextLetterToReveal() {
            revealLetter(letter: letter)
            
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
