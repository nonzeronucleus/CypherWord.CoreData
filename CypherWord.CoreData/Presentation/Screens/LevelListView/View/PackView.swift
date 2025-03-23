import SwiftUI
import Dependencies

struct PackView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @ObservedObject var viewModel: PlayableLevelListViewModel
    
    init(_ viewModel: PlayableLevelListViewModel) {
        self.viewModel = viewModel
    }
    
    let minLevel: Int = 1
//    let maxLevel: Int = 10
    
    var body: some View {
        
        // If in edit model, allow the first empty pack to be shown to allow new levels to be added
        let maxLevel = settingsViewModel.settings.editMode
            ? viewModel.maxLevelNumber + 1
            : viewModel.maxLevelNumber
        
        HStack {
            if var packNumber = viewModel.packNumber {
                
                // Left Button (Decrease Level)
                Button(action: {
                    if packNumber > minLevel {
                        packNumber -= 1
                    }
                    
                    viewModel.packNumber = packNumber
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(packNumber > minLevel ? .blue : .gray)
                        .padding()
                }
                .disabled(viewModel.packNumber == minLevel)
                
                // Current Level Display
                Text("Pack \(packNumber)")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(minWidth: 100)
                
                // Right Button (Increase Level)
                Button(action: {
                    if packNumber < maxLevel {
                        packNumber += 1
                    }
                    viewModel.packNumber = packNumber
                }) {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(packNumber < maxLevel ? .blue : .gray)
                        .padding()
                }
                .disabled(viewModel.packNumber == maxLevel)
            }
            else {
                Text("Loading...")
            }
        }
//        .padding()
    }
}

//
#Preview("Playable - hide completed") {
    @Dependency(\.uuid) var uuid

    let testLayouts = [
        LevelDefinition(id: uuid(), number: 1, packId: nil, attemptedLetters: nil),
        LevelDefinition(id: uuid(), number: 2, packId: nil, attemptedLetters: nil)
    ]
    
    let testPlayableLevels = [
        LevelDefinition(id: uuid(), number: 1, packId: uuid(), attemptedLetters: nil),
        LevelDefinition(id: uuid(), number: 2, packId: uuid(), attemptedLetters: nil, numCorrectLetters: 20),
        LevelDefinition(id: uuid(), number: 3, packId: uuid(), attemptedLetters: nil, numCorrectLetters: 26),
        LevelDefinition(id: uuid(), number: 4, packId: uuid(), attemptedLetters: nil)
    ]
    
    withDependencies {
        $0.levelRepository = FakeLevelRepository(testLayouts: testLayouts, testPlayableLevels: testPlayableLevels)
    } operation: {
        let settingsViewModel = SettingsViewModel(parentId: nil)
        settingsViewModel.settings.showCompletedLevels = false

        let viewModel = PlayableLevelListViewModel(
            navigationViewModel: NavigationViewModel(settingsViewModel: SettingsViewModel(parentId: nil)),
            settingsViewModel:SettingsViewModel(parentId: nil))

        return PackView(viewModel)
            .environmentObject(settingsViewModel)
    }
}
