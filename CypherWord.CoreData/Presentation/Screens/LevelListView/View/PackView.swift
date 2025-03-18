import SwiftUI

struct PackView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var viewModel: PlayableLevelListViewModel
    
    init(_ viewModel: PlayableLevelListViewModel, settingsViewModel: SettingsViewModel) {
        self.viewModel = viewModel
        self.settingsViewModel = settingsViewModel
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
                        .font(.system(size: 32))
                        .foregroundColor(packNumber > minLevel ? .blue : .gray)
                        .padding()
                }
                .disabled(viewModel.packNumber == minLevel)
                
                // Current Level Display
                Text("Pack \(packNumber)")
                    .font(.largeTitle)
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
                        .font(.system(size: 40))
                        .foregroundColor(packNumber < maxLevel ? .blue : .gray)
                        .padding()
                }
                .disabled(viewModel.packNumber == maxLevel)
            }
            else {
                Text("Loading...")
            }
        }
        .padding()
    }
}
