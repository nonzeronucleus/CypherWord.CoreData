import SwiftUI

struct GameView: View {
    @ObservedObject  var model: GameViewModel

    init(_ model: GameViewModel) {
        self.model = model
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    VStack {
                        VStack {
                            ZStack {
                                CrosswordView(
                                    grid: model.level.crossword,
                                    viewMode: .attemptedValue,
                                    letterValues: model.level.letterMap,
                                    selectedNumber: model.selectedNumber,
                                    attemptedletterValues: model.level.attemptedLetters,
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
                            
                            Spacer()
                            
                            Button("Reveal Letter") {
                                model.revealLetter()
                            }
                            
                            Spacer()
                        }
                    }
                }
                VStack {
                    if model.showCompletedDialog {
                        OverlayView(
                            CompletedPopover() {
                                model.showCompletedDialog = false
                            }
                        )
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("< Back") {
                        model.handleBackButtonTap()
                    }
                }
            }
            
        }
    }
}



#Preview {
    let level = LevelDefinition(id: UUID(), number: 1, attemptedLetters: nil)
    let navigationViewModel = NavigationViewModel()
    let model = GameViewModel(level: level, navigationViewModel: navigationViewModel)
    GameView(model)
}
