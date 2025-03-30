import Foundation
import Combine
import Dependencies

@MainActor
class ApplicationViewModel: ObservableObject {
    @Published var settingsViewModel: SettingsViewModel
    @Published var navigationViewModel: NavigationViewModel
    @Published var stateModel: StateModel
    
    init() {
        @Dependency(\.uuid) var uuid

        let settingsViewModel = SettingsViewModel(parentId: uuid())
        let stateModel = StateModel()
        navigationViewModel = NavigationViewModel(settingsViewModel: settingsViewModel, stateModel: stateModel)
        self.stateModel = stateModel
        self.settingsViewModel = settingsViewModel
    }
}
