import Foundation
import Combine
import Dependencies

@MainActor
class ApplicationViewModel: ObservableObject {
    @Published var settingsViewModel: SettingsViewModel
    @Published var navigationViewModel: NavigationViewModel
    
    init() {
        @Dependency(\.uuid) var uuid

        let settingsViewModel = SettingsViewModel(parentId: uuid())
        navigationViewModel = NavigationViewModel(settingsViewModel: settingsViewModel)
        self.settingsViewModel = settingsViewModel
    }
}
