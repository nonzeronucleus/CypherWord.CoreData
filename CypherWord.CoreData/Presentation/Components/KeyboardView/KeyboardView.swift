import SwiftUI

let maxKeysPerRow = 10.0

fileprivate struct KeyboardRow: View {
    private let spacing = 2.0
    private var letters:[Character]
    private let wideActionButtons: Bool
    
    private let onLetterPressed: (Character) -> Void
    private let onDeletePressed: () -> Void
    private let onEnterPressed: () -> Void
    private let usedLetters: Set<Character>
    
    init(_ letters:String,
         wideActionButtons:Bool,
         onLetterPressed:@escaping (Character) -> Void,
         onDeletePressed:@escaping () -> Void = {},
         onEnterPressed:@escaping () -> Void = {},
         usedLetters: Set<Character>
    ){
        self.letters = [Character](letters)
        self.wideActionButtons = wideActionButtons
        self.onLetterPressed = onLetterPressed
        self.onDeletePressed = onDeletePressed
        self.onEnterPressed = onEnterPressed
        self.usedLetters = usedLetters
    }
    
    func getColorForChar(char: Character, letterUsed:Bool) -> Color {
        return letterUsed ?  .gray : Color(UIColor.systemBackground)
    }
    
    var body: some View {
        GeometryReader { geo in
            let actionButtonWidth = wideActionButtons ? geo.size.width / 7 : abs((geo.size.width / maxKeysPerRow) - spacing)
            
            HStack(spacing: spacing) {
                Spacer(minLength: 0)
                ForEach(letters, id: \.self) { letter in
                    let letterUsed = usedLetters.contains(letter)

                    let letterToShow = letter
                    
                    switch letter {
                        case "⌫":
                            ActionKeyView("⌫",
                                      onClick: onDeletePressed,
                                      fontScale:0.6)
                                .frame(width:actionButtonWidth, height: geo.size.height, alignment:.center)
                        case "⏎":
                            ActionKeyView("⏎",
                                      onClick: onEnterPressed,
                                      fontScale:0.5)
                                .frame(width: actionButtonWidth, height: geo.size.height, alignment:.center)
//
                        default:
                            LetterKeyView(letterToShow,
                                          color: getColorForChar(char: letterToShow, letterUsed: letterUsed),
                                          onClick: letterUsed ? {} : { onLetterPressed(letterToShow) }
                                          
                            )
                            .frame(width: abs((geo.size.width/maxKeysPerRow)-spacing), height: geo.size.height, alignment:.center)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }
}




fileprivate struct SharedKeyboard: View {
    private var keys:[String]
    private let wideActionButtons: Bool
    private let onLetterPressed: (Character) -> Void
    private let onDeletePressed: () -> Void
    private let onEnterPressed: (() -> Void)
    private let usedLetters: Set<Character>

    
    init(keys:[String],
        wideActionButtons: Bool = true,
        onLetterPressed:@escaping (Character) -> Void,
        onDeletePressed:@escaping () -> Void,
        onEnterPressed:@escaping () -> Void,
        usedLetters: Set<Character>
    )
    
    {
        self.keys = keys
        self.onLetterPressed = onLetterPressed
        self.onDeletePressed = onDeletePressed
        self.onEnterPressed = onEnterPressed
        self.wideActionButtons = wideActionButtons
        self.usedLetters = usedLetters
    }
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            GeometryReader { geo in
                let keyHeight = geo.size.width/maxKeysPerRow
                    VStack {
                        Spacer()
                        ForEach(keys, id:\.self) { letterRow in
                            KeyboardRow(letterRow,
                                        wideActionButtons: wideActionButtons,
                                        onLetterPressed: onLetterPressed,
                                        onDeletePressed: onDeletePressed,
                                        onEnterPressed: onEnterPressed,
                                        usedLetters: usedLetters
                            )
                                .frame(width: geo.size.width, height: keyHeight, alignment:
                                            .center)
                    }
                }
                .padding(.bottom, keyHeight)
            }
            .frame(alignment: .bottom)
            Spacer(minLength: 0)
        }
        .padding(6)
    }
}


struct LetterKeyboardView: View {
// Variables
    private var lettersNoEnter = [
        "QWERTYUIOP",
        "ASDFGHJKL",
        "ZXCVBNM⌫"
    ]
    
    private var enterLetter = "⏎"
    
    private let onLetterPressed: (Character) -> Void
    private let onDeletePressed: () -> Void
    private let onEnterPressed: () -> Void
    private let showEnter: Bool
    private let usedLetters: Set<Character>

// Init
    init(onLetterPressed:@escaping (Character) -> Void,
         onDeletePressed:@escaping () -> Void = {},
         showEnter: Bool = false,
         onEnterPressed:@escaping () -> Void = {},
         usedLetters: Set<Character>
    ) {
        self.onEnterPressed = onEnterPressed
        self.onLetterPressed = onLetterPressed
        self.onDeletePressed = onDeletePressed
        self.showEnter = showEnter
        self.usedLetters = usedLetters
    }

    private func getLetters() -> [String] {
        var letters = lettersNoEnter
        
        if showEnter {
            letters[letters.count-1].append(enterLetter)
        }
        
        return letters
    }

    var body: some View {
        SharedKeyboard(keys: getLetters(),
                       onLetterPressed:onLetterPressed,
                       onDeletePressed: onDeletePressed,
                       onEnterPressed: onEnterPressed,
                       usedLetters: usedLetters)
    }
}


#Preview("Enter") {
    LetterKeyboardView(onLetterPressed: {_ in }, onDeletePressed: {}, onEnterPressed: {}, usedLetters: [] )
        .padding(20)
}

#Preview("No Enter") {
    LetterKeyboardView(onLetterPressed: {_ in }, onDeletePressed: {}, showEnter: false, usedLetters: [])
        .padding(20)
}

