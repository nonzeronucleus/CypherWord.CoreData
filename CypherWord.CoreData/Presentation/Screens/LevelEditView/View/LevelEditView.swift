import SwiftUI
import Foundation
import Dependencies

public struct LevelEditView: View {
    @State private var showAlert = false
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
                
                ZStack {
                    ZoomableScrollView {
                        CrosswordView(grid: model.level.crossword,
                                      viewMode: .actualValue,
                                      letterValues: model.level.letterMap,
                                      attemptedletterValues: nil,
                                      performAction: { id in
                            model.toggleCell(id: id)
                        })
                        
                        if let error = model.error {
                            Text(error)
                        }
                    }
                    .padding(20)
                    
                    if model.isBusy {
                        OverlayView(
                            VStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(2.5)
                                
                                Button("Cancel") {
                                    model.cancel()
                                }
                            }
                        )
                    }
                }
                
                Button("Save") {
                    model.save()
                }
                Button("Populate") {
                    model.populate()
                }
                Button("Delete") {
                    model.delete()
                }
                
                if (model.level.crossword.isPopulated) {
                    Button("Reset") {
                        model.reset()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("< Back") {
                        model.handleBackButtonTap()
                    }  // showAlert = true
                }
            }
            .alert("Save changes?", isPresented: $model.showAlert) {
                Button("Yes", role: .destructive) { model.handleSaveChangesButtonTap() }
                Button("No", role: .destructive) { model.goBack() }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

#Preview {
    @Dependency(\.uuid) var uuid

    let id = uuid()
    let stateModel = StateModel()
    let navigationViewModel = NavigationViewModel(settingsViewModel: SettingsViewModel(parentId: id), stateModel: stateModel)
    let level = LevelDefinition(id: uuid(), number: 1, packId: nil, gridText: " ...|.. .|. ..|. ..|", letterMap: nil, attemptedLetters: nil)
    let viewModel = LevelEditViewModel(levelDefinition: level, navigationViewModel: navigationViewModel, stateModel: StateModel())
    
    LevelEditView(viewModel)
}
