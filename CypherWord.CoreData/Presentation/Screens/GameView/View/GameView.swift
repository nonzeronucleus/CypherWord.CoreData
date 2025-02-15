import SwiftUI

struct GameView: View {
    @ObservedObject  var model: GameViewModel

    init(_ model: GameViewModel) {
        self.model = model
    }

    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                VStack {
                    ZStack {
                        if let crossword = model.crossword {
                            CrosswordView(
                                grid: crossword,
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
                    
                    Spacer()

                    Button("Reveal Letter") {
                        model.revealLetter()
                    }
                    
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


#Preview {
    let level = Level(id: UUID(), number: 1, attemptedLetters: nil)
    let navigationViewModel = NavigationViewModel()
    let model = GameViewModel(level: level, navigationViewModel: navigationViewModel)
    GameView(model)
}
