import SwiftUI
import Foundation

public struct LevelEditView: View {
    @ObservedObject  var model: LevelEditViewModel
    
    init(_ model: LevelEditViewModel) {
        self.model = model
    }
    
    
    public var body: some View {
        ZStack {
            VStack {
                Slider(
                    value: Binding(
                        get: {
                            Double(exactly: model.size)!
                        },
                        set: {(newValue) in
                            let intValue = Int(newValue)
                            if intValue != model.size {
                                model.resize(newSize: intValue)
                            }
                        }),
                    in: 5...19,
                    step: 2.0
                )
                Text("\(model.size)")
                CrosswordView(grid: model.crossword,
                              viewMode: .actualValue,
                              letterValues: model.letterValues,
                              performAction: { id in
                    model.toggleCell(id: id)
                })
                Button("Save") {
                    model.save()
                }
                Button("Populate") {
                    model.populate()
                }
                //            if (levelModel.crossword.isPopulated) {
                //                Button("Reset") {
                //                    model.reset()
                //                }
                //            }
                
                if let error = model.error {
                    Text(error)
                }
            }
            .padding(20)
            if model.isBusy {
                ZStack {
                    let _ = print("X")
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                    
                    // A progress spinner centered on the overlay.
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2.5)
                }
            }
        }

    }
    
}

#Preview {
    let level = Level(id: UUID(), number: 1, gridText: " ...|.. .|. ..|. ..|", letterMap: nil)
    let viewModel = LevelEditViewModel(level: level)
    
    LevelEditView(viewModel)
}
