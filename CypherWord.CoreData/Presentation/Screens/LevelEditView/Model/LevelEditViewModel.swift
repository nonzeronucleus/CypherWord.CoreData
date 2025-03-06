import Foundation
import SwiftUICore
import Dependencies

@MainActor
class LevelEditViewModel: ObservableObject {
    enum EditState {
        case clean
        case changed
        case populated
    }

    private var saveLevelUseCase: SaveLevelUseCaseProtocol
    private var deleteLevelUseCase: DeleteLevelUseCaseProtocol
    private var addPlayableLevelUseCase: AddPlayableLevelUseCaseProtocol
    private var resizeGridUseCase: ResizeGridUseCaseProtocol
    
    private let navigationViewModel: NavigationViewModel

    static let defaultSize = 11
    @Published var level: Level
    @Published var size: Int
    @Published private(set) var error:String?
    @Published var isBusy: Bool = false
    @Published var showAlert: Bool = false
    
    var currentState = EditState.clean
    
    private var populateTask: Task<Void, Never>? // Stores the running task
    private var resizeTask: Task<Void, Never>? // Stores the running task

    init(levelDefinition:LevelDefinition,
         navigationViewModel:NavigationViewModel,
         saveLevelUseCase: SaveLevelUseCaseProtocol = SaveLevelUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue),
         deleteLevelUseCase: DeleteLevelUseCaseProtocol = DeleteLevelUseCase(repository: Dependency(\.levelRepository).wrappedValue),
         addPlayableLevelUseCase: AddPlayableLevelUseCaseProtocol = AddPlayableLevelUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue),
         resizeGridUseCase: ResizeGridUseCaseProtocol = ResizeGridUseCase()
    ) {
        self.saveLevelUseCase = saveLevelUseCase
        self.deleteLevelUseCase = deleteLevelUseCase
        self.addPlayableLevelUseCase = addPlayableLevelUseCase
        self.navigationViewModel = navigationViewModel
        self.resizeGridUseCase = resizeGridUseCase

        let level = Level(definition: levelDefinition)
        self.level = level
        
        self.size = level.crossword.columns
    }
    
    func toggleCell(id: UUID) {
        if currentState == .populated {
            // TODO flag alert about changing a populated crossword
            return
        }
        
        if let location = level.crossword.locationOfElement(byID: id) {
            level.crossword.updateElement(byPos: location) { cell in
                cell.toggle()
                currentState = .changed
            }
            let opposite = Pos(row: level.crossword.columns - 1 - location.row, column: level.crossword.rows - 1 - location.column)
            
            if opposite != location {
                level.crossword.updateElement(byPos: opposite) { cell in
                    cell.toggle()
                }
            }
        }
    }
    
    func reset() {
        for row in 0..<level.crossword.rows {
            for col in 0..<level.crossword.columns {
                var cell = level.crossword[row, col]
                if cell.letter != nil {
                    cell.letter = " "
                }
                level.crossword[row, col] = cell
            }
        }
        currentState = .clean
    }

    @MainActor
    func delete() {
        isBusy = true
        
        Task {
            do {
                try await deleteLevelUseCase.execute(levelID: level.id)
                goBack()
            }
            catch {
                self.error = error.localizedDescription
            }
        }
    }
 
    
    @MainActor
    func save(then onComplete: @escaping (() -> Void) = {}) {
        isBusy = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch currentState {
                case .clean:
                    isBusy = false
                    break
                case .populated:
                    savePlayableLevel()
                    currentState = .clean
                    isBusy = false
                    onComplete()
                case .changed:
                    saveLayout()
                    currentState = .clean
                    isBusy = false
                    onComplete()
            }
        }
    }
    
    @MainActor
    private func saveLayout() {
        var levelDefinition = LevelDefinition(from: level)
        levelDefinition.letterMap = nil
        
        Task {
            
            do {
                try await saveLevelUseCase.execute(level: levelDefinition)
                self.isBusy = false
            }
            catch {
                self.isBusy = false
                self.error = error.localizedDescription
            }
        }
    }
    
    private func savePlayableLevel() {
        isBusy = true
        Task {
            let levelDefinition = LevelDefinition(from: level)
            
            do {
                isBusy = false
                try await addPlayableLevelUseCase.execute(level: levelDefinition)
            }
            catch {
                isBusy = false
                self.error = error.localizedDescription
            }
        }
    }


    @MainActor
    func populate() {
        print("if not clean, ask about saving")
        
        isBusy = true

        populateTask = Task {
            do {
                let populator = CrosswordPopulatorUseCase()
                let (newCrossword, characterIntMap) = try await populator.executeAsync(initCrossword: self.level.crossword)

                // Before updating the UI, check if the task was cancelled
                guard !Task.isCancelled else { return }

                self.level.crossword = newCrossword
                self.level.letterMap = characterIntMap
                self.currentState = .populated
                isBusy = false
            } catch {
                if Task.isCancelled {
                    print("Populate task was cancelled")
                } else {
                    print("Error in populate: \(error)")
                }
                isBusy = false
            }
        }
    }
        
        
        
    func handleBackButtonTap() {
        if currentState == .clean {
            goBack()
        }
        else {
            showAlert = true
        }
    }
    
    @MainActor
    func handleSaveChangesButtonTap() {
        save(then: goBack)
    }
    
    func goBack() {
        navigationViewModel.goBack()
    }


    
    
    // Call this function from your UI button
    @MainActor
    func cancel() {
        if let populateTask = populateTask {
            populateTask.cancel()
        }
        isBusy = false // Update UI to remove spinner
    }
    
    @MainActor
    func resize(newSize: Int) {
        guard size != newSize else { return }

//        size = newSize
        
//        isBusy = true
        resizeTask?.cancel() // Cancel any existing task

        resizeTask = Task { [weak self] in
            do {
                guard let self else { return } // Swift 5.9 shorthand for `guard let self = self else { return }`
                
                let newCrossword = try await resizeGridUseCase.execute(inputGrid: level.crossword, newSize: newSize)
                
                guard !Task.isCancelled else { return }
                
                self.level.crossword = newCrossword
                self.size = newSize
            }
            catch {
                self?.error = error.localizedDescription
            }
        }
    }
}

