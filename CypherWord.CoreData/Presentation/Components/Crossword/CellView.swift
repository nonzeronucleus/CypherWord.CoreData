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
            let numberFontSize = CGFloat(squareSize * 0.25)
            let characterFontSize = CGFloat(squareSize * 0.75)
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
                    // Number in the top left corner
                    
                    if let number {
                        Text(String(number+1))
                            .font(.system(size: numberFontSize))
                            .padding(4)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .offset(x: -squareSize * 0.10, y: -squareSize * 0.1) // Push number slightly up and left
                    }
                    
                    // Character in the center
                    let character = String(letter)
                    
                    Text(character)
                        .font(.system(size: characterFontSize))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(squareSize * 0.05)
                        .offset(x: squareSize * 0.08, y: squareSize * 0.08)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit) // Ensures the view remains square
    }
    
    func calcColor() -> Color? {
        var color:Color?
        
//        switch checkStatus {
//            case .normal:
//                color = (selected ? .gray : nil)
//            case .correct:
//                color = (selected ? .mint : .green)
//            case .incorrect:
//                color = (selected ? .orange : .red)
//        }

        switch checkStatus {
            case .normal:
                color = .white
            case .correct:
                color = .green
            case .incorrect:
                color = .red
        }
        
//        return color?.opacity(selected ? 0.8 : 1.0)
        return color?.darkened(by: (selected ? 0.4 : 0.0))
    }
}

#Preview("Normal") {
    VStack {
        CellView(letter:"Z", number: 25)
            .frame(width: 60, height: 60, alignment: .center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
    .accentColor(Color.black)
    .background(Color.gray)
}

#Preview("Unselected correct") {
    VStack {
        CellView(letter:"B", number: 2, selected: false, checkStatus: .correct)
            .frame(width: 60, height: 60, alignment: .center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
    .accentColor(Color.black)
    .background(Color.gray)
}

#Preview("Unselected wrong") {
    VStack {
        CellView(letter:"C", number: 2, selected: false, checkStatus: .incorrect)
            .frame(width: 60, height: 60, alignment: .center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
    .accentColor(Color.black)
    .background(Color.gray)
}


#Preview("Selected correct") {
    VStack {
    CellView(letter:"D", number: 2, selected: true, checkStatus: .correct)
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





#Preview("Attempted blank") {
    CellView(letter: " ")
        .frame(width: 60, height: 60, alignment: .center)
}

#Preview("Attempted with letter") {
    CellView(letter: "A", number: 3, selected: false, checkStatus: .correct)
        .frame(width: 60, height: 60, alignment: .center)
}

