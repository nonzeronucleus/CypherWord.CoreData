import Foundation
import Combine

class ApplicationViewModel: ObservableObject {
    @Published var settingsViewModel: SettingsViewModel
    @Published var navigationViewModel: NavigationViewModel
    
    init() {
        let settingsViewModel = SettingsViewModel(parentId: UUID())
        navigationViewModel = NavigationViewModel(settingsViewModel: settingsViewModel)
        self.settingsViewModel = settingsViewModel
    }
}
