import Foundation
import SwiftUICore
import Dependencies


class LevelEditViewModel: ObservableObject {
    enum EditState {
        case clean
        case changed
        case populated
    }

    @Dependency(\.saveLevelUseCase) private var saveLevelUseCase: SaveLevelUseCaseProtocol
    @Dependency(\.deleteLevelUseCase) private var deleteLevelUseCase: DeleteLevelUseCaseProtocol
    @Dependency(\.addPlayableLevelUseCase) private var addPlayableLevelUseCase: AddPlayableLevelUseCaseProtocol
    private let navigationViewModel: NavigationViewModel

    static let defaultSize = 11
//    @Published private(set) var levelDefinition: LevelDefinition
    @Published var level: Level
    @Published var size: Int
//    @Published var crossword: Crossword
    @Published private(set) var error:String?
//    @Published var letterValues: CharacterIntMap?
    @Published var isBusy: Bool = false
    @Published var showAlert: Bool = false
    
    var currentState = EditState.clean
    
    private var populateTask: Task<Void, Never>? // Stores the running task
    
    init(levelDefinition:LevelDefinition, navigationViewModel:NavigationViewModel) {
//        self.levelDefinition = levelDefinition
        self.navigationViewModel = navigationViewModel
//        var newCrossword:Crossword?
//        
//        let transformer = CrosswordTransformer()
        
//        if let gridText = levelDefinition.gridText {
//            newCrossword = transformer.reverseTransformedValue(gridText) as? Crossword
//        }
//        
//        if let letterValuesText = levelDefinition.letterMap
//        {
//            let letterValues = CharacterIntMap(from: letterValuesText)
//            self.letterValues = letterValues
//        }
//        
//        if newCrossword == nil {
//            newCrossword = Crossword(rows: 15, columns: 15)
//        }
//        
//        crossword = newCrossword!
//
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
    
    func delete() {
        isBusy = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            deleteLevelUseCase.execute(levelID: level.id, completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                        case .success():
                            self?.isBusy = false
                            self?.goBack()
                        case .failure(let error):
                            self?.error = error.localizedDescription
                    }
                }
            })
        }
    }
    
    
    func save(then onComplete: @escaping (() -> Void) = {}) {
        isBusy = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
//            let crosswordTransformer = CrosswordTransformer()
//            
//            levelDefinition.gridText = crosswordTransformer.transformedValue(crossword) as? String
            
            switch currentState {
                case .clean:
                    break
                case .populated:
//                    levelDefinition.letterMap = letterValues?.toJSON()
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
    
    private func saveLayout() {
        let levelDefinition = LevelDefinition(from: level)
        
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
    
    private func savePlayableLevel() {
        let levelDefinition = LevelDefinition(from: level)
        
        addPlayableLevelUseCase.execute(level: levelDefinition, completion: { [weak self] result in
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

    
    @MainActor
    func populate() {
        // if not clean, ask about saving
        print("if not clean, ask about saving")
        
        isBusy = true
        populateTask?.cancel() // Cancel any existing task

        populateTask = Task { [weak self] in
            guard let self else { return } // Swift 5.9 shorthand for `guard let self = self else { return }`
            
            let populator = CrosswordPopulatorUseCase()
            let result = await populator.executeAsync(initCrossword: self.level.crossword)

            guard !Task.isCancelled else { return }

            await MainActor.run { // Ensure UI updates happen on the main thread
                switch result {
                    case .success(let (newCrossword, characterIntMap)):
                        self.level.crossword = newCrossword
                        self.level.letterMap = characterIntMap
                        self.currentState = .populated
                    case .failure(let error):
                        self.error = error.localizedDescription
                }
                self.isBusy = false
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
    
    func handleSaveChangesButtonTap() {
        save(then: goBack)
    }
    
    func goBack() {
        navigationViewModel.goBack()
    }


    
    
    // Call this function from your UI button
    func cancel() {
        if let populateTask = populateTask {
            populateTask.cancel()
        }
//        populateTask?.cancel()
        isBusy = false // Update UI to remove spinner
    }
    
    func resize(newSize: Int) {
        guard size != newSize else { return }

//        let resizer = Resizer(newSize: newSize)

        size = newSize
//        crossword = resizer.perform(inputGrid: crossword)
    }
}

