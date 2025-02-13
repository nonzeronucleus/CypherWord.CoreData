import SwiftUI

struct GameView: View {
    @ObservedObject  var model: GameViewModel

    init(_ model: GameViewModel) {
        self.model = model
    }

    var body: some View {
        GeometryReader { geometry in
            
            VStack {
//                HStack {
//                    
//                    Text(model.level.levelType == .playable ? "Level":"Layout")
//                        .frame(maxWidth: .infinity)
//                        .padding(CGFloat(integerLiteral: 16))
//                        .font(.system(size: 32, weight: .bold, design: .rounded))
//                        .background(Color.blue)
//                }
//                
                VStack {
                    ZStack {
                        CrosswordView(
                            grid: model.crossword,
                            viewMode: .attemptedValue,
                            letterValues: model.letterValues,
                            selectedNumber: model.selectedNumber,
                            attemptedletterValues: model.attemptedValues,
                            checking: model.checking,
                            performAction: {
                                id in model.onCellClick(id: id)
                            })
                            .frame(width: geometry.size.width * 0.98, height: geometry.size.width * 0.98) // Lock height to 98% of the screen
                            .border(.gray)
                            .padding(.top,10)
                        
                    }

                    Spacer()
                    
                    // Keyboard at the bottom
                    LetterKeyboardView(
                        onLetterPressed: { letter in model.onLetterPressed(letter: letter) },
                        onDeletePressed: model.onDeletePressed,
                        showEnter: false,
                        usedLetters: model.usedLetters
                    )
                    .padding(20)
                    Spacer()
                }
                .confirmationDialog("Save changes?",
                                    isPresented: $model.showingConfirmation) {
                    Text("Save Changes?")
                    Button("Save and exit", role: .none) {
                        model.exit()
                    }
                    Button("Exit without saving", role: .destructive) {
                        model.exit()
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button("Check") {
                        model.checkLetters()
                    }
//                    
//                    Spacer()

//                    Button("Save") {
////                        save()
//                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("< Back") {
                        model.handleBackButtonTap()
                    }  // showAlert = true
                }
            }

        }
    }
}

//extension GameView {
//    
//    func onCellClick(id:UUID) {
////        if completed {
////            return
////        }
////
////        checking = false
////
//        let cell = crossword.findElement(byID: id)
////
//        if let cell = cell {
//            if let letter = cell.letter {
//                if let number = letterValues?[letter] {
//                    selectedNumber = number
//                }
//            }
//        }
//    }
//    
//    func handleBackButtonTap() {
//        if hasChanged {
//            showingConfirmation = true
//        }
//        else {
//            exit()
//        }
//    }
//    
//    func exit() {
//        showingConfirmation = false
//        selectedLevel = nil
//    }
//    
////    func generate() {
////        let populator = CrosswordPopulator(crossword: crossword)
////        
////        let populated = populator.populateCrossword()
////        
////        crossword = populated.crossword
////        
////        letterValues = populated.characterIntMap
////        isPopulated = true
////        
////    }
//}


#Preview {
    let level = Level(id: UUID(), number: 1, attemptedLetters: nil)
    let navigationViewModel = NavigationViewModel()
    let model = GameViewModel(level: level, navigationViewModel: navigationViewModel)
    GameView(model)
}
