import Foundation
import Dependencies


//@Binding var selectedLevel : Level?
//@State var showingConfirmation: Bool = false
//@State var backgroundColor: Color = .white
//@State var crossword : Crossword
//@State var letterValues:CharacterIntMap?
//@State var hasChanged: Bool = false
//@State var isPopulated: Bool = false
//@State var selectedNumber: Int?

class GameViewModel: ObservableObject {
    @Dependency(\.fetchLevelByIDUseCase) private var fetchLevelByIDUseCase: FetchLevelByIDUseCaseProtocol

    static let defaultSize = 11
    @Published private(set) var level: Level
    @Published var size: Int
    @Published var crossword: Crossword
    @Published private(set) var error:String?
    @Published var letterValues: CharacterIntMap?
    @Published var isPopulated: Bool = false
    @Published var isBusy: Bool = false
    @Published var showingConfirmation: Bool = false
    @Published var selectedNumber: Int?
    @Published var hasChanged: Bool = false
    @Published var selectedLevel : Level?
    private let navigationViewModel: NavigationViewModel
    
    
    init(level:Level, navigationViewModel:NavigationViewModel) {
        self.level = level
        var newCrossword:Crossword?
        self.navigationViewModel = navigationViewModel
        
        let transformer = CrosswordTransformer()
        
        guard let gridText = level.gridText else {
            error = "Could not load crossword grid"
            crossword = Crossword(rows: 15, columns: 15)
            size = 15
            
            return
        }
        newCrossword = transformer.reverseTransformedValue(gridText) as? Crossword
        
        if let letterValuesText = level.letterMap
        {
            let letterValues = CharacterIntMap(from: letterValuesText)
            self.letterValues = letterValues
        }
        
        guard newCrossword != nil else {
            crossword = Crossword(rows: 15, columns: 15)
            size = 15
            
            return
        }
        
        crossword = newCrossword!
        
        size = newCrossword!.columns
    }
    
    func onCellClick(id:UUID) {
        //        if completed {
        //            return
        //        }
        //
        //        checking = false
        //
        let cell = crossword.findElement(byID: id)
        //
        if let cell = cell {
            if let letter = cell.letter {
                if let number = letterValues?[letter] {
                    selectedNumber = number
                }
            }
        }
    }
    
    func handleBackButtonTap() {
        if hasChanged {
            showingConfirmation = true
        }
        else {
            navigationViewModel.goBack()
//          exit()
        }
    }
    
    func exit() {
        showingConfirmation = false
//        level = nil
    }
    
    
}
