import Foundation
import Dependencies


class LevelEditViewModel: ObservableObject {
    @Dependency(\.saveLevelUseCase) private var saveLevelUseCase: SaveLevelUseCaseProtocol
    @Dependency(\.addPlayableLevelUseCase) private var addPlayableLevelUseCase: AddPlayableLevelUseCaseProtocol

    static let defaultSize = 11
    @Published private(set) var level: Level
    @Published var size: Int
    @Published var crossword: Crossword
    @Published private(set) var error:String?
    @Published var letterValues: CharacterIntMap?
    @Published var isPopulated: Bool = false
    @Published var isBusy: Bool = false
    
    init(level:Level) {
        self.level = level
        var newCrossword:Crossword?
        
        let transformer = CrosswordTransformer()
        
        if let gridText = level.gridText {
            newCrossword = transformer.reverseTransformedValue(gridText) as? Crossword
        }
        
        if let letterValuesText = level.letterMap
        {
            let letterValues = CharacterIntMap(from: letterValuesText)
            self.letterValues = letterValues
        }
        
        if newCrossword == nil {
            newCrossword = Crossword(rows: 15, columns: 15)
        }
        
        crossword = newCrossword!
        
        size = newCrossword!.columns
    }
    
    func toggleCell(id: UUID) {
        if let location = crossword.locationOfElement(byID: id) {
            crossword.updateElement(byPos: location) { cell in
                cell.toggle()
            }
            let opposite = Pos(row: crossword.columns - 1 - location.row, column: crossword.rows - 1 - location.column)
            
            if opposite != location {
                crossword.updateElement(byPos: opposite) { cell in
                    cell.toggle()
                }
            }
        }
    }
    
    func reset() {
        for row in 0..<crossword.rows {
            for col in 0..<crossword.columns {
                var cell = crossword[row, col]
                if cell.letter != nil {
                    cell.letter = " "
                }
//                cell.isActive = false
                crossword[row, col] = cell
            }
        }
        isPopulated = false
    }
    func save() {
        isBusy = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let crosswordTransformer = CrosswordTransformer()
            
            level.gridText = crosswordTransformer.transformedValue(crossword) as? String
            
            if isPopulated {
                level.letterMap = letterValues?.toJSON()
                savePlayableLevel()
            }
            else {
                // Save current layout
                saveLayout()
            }
        }
    }
    
    private func saveLayout() {
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
    
    private func savePlayableLevel() {
        addPlayableLevelUseCase.execute(level: level, completion: { [weak self] result in
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

    
    func populate() {
        isBusy = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let populator = CrosswordPopulatorUseCase()
            
            populator.execute(initCrossword: crossword) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let (newCrossword, characterIntMap)):
                            self?.crossword = newCrossword
                            self?.letterValues = characterIntMap
                            self?.isBusy = false
                            self?.isPopulated = true
                            
                            // You can also do something with characterIntMap if needed
                        case .failure(let error):
                            self?.error = error.localizedDescription
                            self?.isBusy = false
                    }
                }
            }
        }
    }
    
    func resize(newSize: Int) {
        guard size != newSize else { return }

//        let resizer = Resizer(newSize: newSize)

        size = newSize
//        crossword = resizer.perform(inputGrid: crossword)
    }
}

