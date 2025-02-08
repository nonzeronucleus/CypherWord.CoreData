import SwiftUI

struct GameView: View {
    @Binding var selectedLevel : Level?
    @State var showingConfirmation: Bool = false
    @State var backgroundColor: Color = .white
    @State var crossword : Crossword
    @State var letterValues:CharacterIntMap?
    @State var hasChanged: Bool = false
    @State var isPopulated: Bool = false
    @State var selectedNumber: Int?


    init(selectedLevel: Binding<Level?>) {
        self._selectedLevel = selectedLevel
        var crossword:Crossword? = nil
        
        if let level = selectedLevel.wrappedValue {
            let transformer = CrosswordTransformer()
            
            if let gridText = level.gridText {
                if !gridText.isEmpty {
                    crossword = transformer.reverseTransformedValue(gridText) as? Crossword ?? Crossword(rows: 15, columns: 15)
                }
            }
        }
        
        self.crossword = crossword ?? Crossword(rows: 15, columns: 15)
    }

    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                if let selectedLevel {
                    Text(selectedLevel.levelType == .playable ? "Level":"Layout")
                        .frame(maxWidth: .infinity)
                        .padding(CGFloat(integerLiteral: 32))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .background(Color.blue)
                }
                
                VStack {
                    ZStack {
                        CrosswordView(grid: crossword, viewMode: .actualValue, performAction: { id in onCellClick(id: id) })
                            .frame(width: geometry.size.width * 0.98, height: geometry.size.width * 0.98) // Lock height to 98% of the screen
                            .border(.gray)
                            .padding(.top,10)
                    }

                    Spacer()
                }
                .confirmationDialog("Save changes?",
                                    isPresented: $showingConfirmation) {
                    Text("Save Changes?")
                    Button("Save and exit", role: .none) {
//                        save()
                        exit()
                    }
                    Button("Exit without saving", role: .destructive) {
                        exit()
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button("Go Back") {
                        handleBackButtonTap()
                    }
                    
                    Spacer()

                    Button("Save") {
//                        save()
                    }
                    
                    Spacer()

                    Button("Generate") {
//                        generate()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

extension GameView {
    
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
            exit()
        }
    }
    
    func exit() {
        showingConfirmation = false
        selectedLevel = nil
    }
    
//    func generate() {
//        let populator = CrosswordPopulator(crossword: crossword)
//        
//        let populated = populator.populateCrossword()
//        
//        crossword = populated.crossword
//        
//        letterValues = populated.characterIntMap
//        isPopulated = true
//        
//    }
}
