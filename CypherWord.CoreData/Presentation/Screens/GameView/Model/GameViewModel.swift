import Foundation
import Dependencies

class GameViewModel: ObservableObject {
    private var saveLevelUseCase: SaveLevelUseCaseProtocol

    @Published private(set) var error:String?
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
        self.level = Level(definition: level)
        self.navigationViewModel = navigationViewModel
        
        Task {
            await revealLetter(letter: "X")
            await revealLetter(letter: "Z")
        }
    }
    
    
    func revealLetter(letter:Character) async {
        let val = level.letterMap![letter]
        
        if let val {
            await setAttemptedValue(idx: val, char: letter)
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
            Task {
                await setAttemptedValue(idx: selectedNumber, char: letter)
            }
        }
    }
    
//    @MainActor
    func save() async {
        await MainActor.run {
            isBusy = true
        }
        do {
            try await saveProgress()
            await MainActor.run {
                isBusy = false
            }
        }
        catch {
            await MainActor.run {
                self.error = error.localizedDescription
                isBusy = false
            }
        }
    }

    
    @MainActor
    private func saveProgress() async throws {
        let levelDefinition = LevelDefinition(from: level)
        try await saveLevelUseCase.execute(level: levelDefinition)
        isBusy = false
    }
    
    
    @MainActor func onDeletePressed() {
        if completed {
            return
        }

        checking = false
        if let selectedNumber {
            Task {
                await setAttemptedValue(idx: selectedNumber, char: " ")
            }
        }
    }
    
    @MainActor private func setAttemptedValue(idx: Int, char:Character) async {
        let prevNumCorrectLetters = level.numCorrectLetters
        level.attemptedLetters[idx] = char

        if prevNumCorrectLetters < 26 && level.numCorrectLetters == 26 {
            showCompletedDialog = true
        }
        numCorrectLetters = level.numCorrectLetters
        await save()
    }
    
    func checkLetters() {
        checking.toggle()
    }
    
    @MainActor
    func revealNextLetter() {
        if let letter = level.getNextLetterToReveal() {
            Task {
                await revealLetter(letter: letter)
            }
        }
    }
    
    var usedLetters: Set<Character> {
        Set(level.attemptedLetters.filter { $0 != " " })
    }
    
    func handleBackButtonTap() {
        if let navigationViewModel {
            Task {
                await navigationViewModel.goBack()
            }
        }
    }
    
    func exit() {
        showingConfirmation = false
    }
}
