import SwiftUI

struct GameView: View {
    @ObservedObject  var model: GameViewModel

    init(_ model: GameViewModel) {
        self.model = model
    }

    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Text(model.level.levelType == .playable ? "Level":"Layout")
                    .frame(maxWidth: .infinity)
                    .padding(CGFloat(integerLiteral: 32))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .background(Color.blue)
                
                VStack {
                    ZStack {
                        CrosswordView(grid: model.crossword, viewMode: .actualValue, performAction: { id in model.onCellClick(id: id) })
                            .frame(width: geometry.size.width * 0.98, height: geometry.size.width * 0.98) // Lock height to 98% of the screen
                            .border(.gray)
                            .padding(.top,10)
                    }

                    Spacer()
                }
                .confirmationDialog("Save changes?",
                                    isPresented: $model.showingConfirmation) {
                    Text("Save Changes?")
                    Button("Save and exit", role: .none) {
//                        save()
                        model.exit()
                    }
                    Button("Exit without saving", role: .destructive) {
                        model.exit()
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button("Go Back") {
                        model.handleBackButtonTap()
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
