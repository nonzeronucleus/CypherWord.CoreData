import SwiftUI


struct CellView: View {
    var selected: Bool = false
    var number: Int?
    var letter: Character?
    var checkStatus: Status
    
    enum Status {
        case normal
        case correct
        case incorrect
    }
    
    init(letter:Character?, number: Int? = nil, selected:Bool = false, checkStatus:Status = .normal) {
        self.number = number
        self.selected = selected
        
        self.letter = letter
        self.checkStatus = checkStatus
    }
    
    var body: some View {
        GeometryReader { geometry in
            let squareSize = min(geometry.size.width, geometry.size.height)
            let numberFontSize = CGFloat(squareSize * 0.2)
            let characterFontSize = CGFloat(squareSize * 0.5)
            let cellColor = calcColor()
            
            ZStack(alignment: .topLeading) {
                // Background square

                Rectangle()
                    .fill(.black)
                    .border(.black)

                if let letter = letter {
                    Rectangle()
                        .fill(.white)
                        .border(.black)


                    if let cellColor {
                        Rectangle()
                            .fill(cellColor)
                            .border(.black)
                    }
//
//                    Rectangle()
//                        .stroke(lineWidth: 2)
//                        .fill(.black)
//                        .foregroundColor(.black)
//                    // Number in the top left corner
                    if let number {
                        Text(String(number+1))
                            .font(.system(size: numberFontSize)) // Explicitly setting font
                            .padding(4)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    
                    // Character in the center
                    let character = String(letter)
                    
                    Text(character)
                        .font(.system(size: characterFontSize)) // Explicitly setting font
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(squareSize * 0.2) // Center by padding
//                }
//                else {
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.black)
//                        Rectangle()
//                            .stroke(lineWidth: 2)
//                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit) // Ensures the view remains square
    }
    
    func calcColor() -> Color? {
        switch checkStatus {
            case .normal:
                return (selected ? .gray : nil)
            case .correct:
                return (selected ? .mint : .green)
            case .incorrect:
                return (selected ? .orange : .red)
        }
    }
}

#Preview("Normal") {
    VStack {
        CellView(letter:"A", number: 2)
            .frame(width: 60, height: 60, alignment: .center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
    .accentColor(Color.black)
    .background(Color.gray)
}

#Preview("Unselected correct") {
    VStack {
        CellView(letter:"A", number: 2, selected: false, checkStatus: .correct)
            .frame(width: 60, height: 60, alignment: .center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
    .accentColor(Color.black)
    .background(Color.gray)
}

#Preview("Unselected wrong") {
    VStack {
        CellView(letter:"A", number: 2, selected: false, checkStatus: .incorrect)
            .frame(width: 60, height: 60, alignment: .center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
    .accentColor(Color.black)
    .background(Color.gray)
}


#Preview("Unselected correct") {
    VStack {
    CellView(letter:"A", number: 2, selected: true, checkStatus: .correct)
        .frame(width: 60, height: 60, alignment: .center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
    .accentColor(Color.black)
    .background(Color.gray)
}

#Preview("Selected wrong") {
    VStack {
    CellView(letter:"A", number: 2, selected: true, checkStatus: .incorrect)
        .frame(width: 60, height: 60, alignment: .center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
    .accentColor(Color.black)
    .background(Color.gray)
}



//
//
//#Preview("Attempted blank") {
//    let cell = Cell(pos: Pos.nilPos, letter: "C")
//
//    CellView(cell: cell, number: 3, mode: .attemptedValue)
//        .frame(width: 60, height: 60, alignment: .center)
//}
//
//#Preview("Attempted with letter") {
//    var cell = Cell(pos: Pos.nilPos, letter: "D")
//    cell.attemptedLetter = "X"
//
//    return CellView(cell: cell, number: 2, mode: .attemptedValue)
//        .frame(width: 60, height: 60, alignment: .center)
//}

