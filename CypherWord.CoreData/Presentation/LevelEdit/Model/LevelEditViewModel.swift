import Foundation
import Dependencies


class LevelEditViewModel: ObservableObject {
    @Dependency(\.saveLevelUseCase) private var saveLevelUseCase: SaveLevelUseCaseProtocol

    static let defaultSize = 11
    @Published private(set) var level: Level
    @Published var size: Int
    @Published var crossword: Crossword
    @Published private(set) var error:String?
    @Published var letterValues: CharacterIntMap?
    @Published var isPopulated: Bool = false
    
    init(level:Level) {
        self.level = level
        var newCrossword:Crossword?
        
        let transformer = CrosswordTransformer()
        
        if let gridText = level.gridText {
            newCrossword = transformer.reverseTransformedValue(gridText) as? Crossword
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
    
    func save() {
        let crosswordTransformer = CrosswordTransformer()
        
        level.gridText = crosswordTransformer.transformedValue(crossword) as? String
        
        saveLevelUseCase.execute(level: level, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    break
//                    self?.levels = levels
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            }
        })
    }
    
    func generate() {
//        let populator = CrosswordPopulatorService(crossword: crossword)
//        
//        let populated = populator.populateCrossword()
//        
//        crossword = populated.crossword
//        
//        letterValues = populated.characterIntMap
//        isPopulated = true
    }
    
    func resize(newSize: Int) {
        guard size != newSize else { return }

//        let resizer = Resizer(newSize: newSize)

        size = newSize
//        crossword = resizer.perform(inputGrid: crossword)
    }
}

