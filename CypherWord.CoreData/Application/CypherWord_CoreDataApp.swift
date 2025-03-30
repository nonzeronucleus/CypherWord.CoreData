import SwiftUI

@main
struct CypherWord_CoreDataApp: App {
    @StateObject var applicationViewModel = ApplicationViewModel()
    @StateObject var navigationViewModel: NavigationViewModel
    @StateObject var settingsViewModel: SettingsViewModel
    @StateObject var stateModel: StateModel

    init() {
        // Register default settings
        UserDefaults.standard.register(defaults: [
            "ShowCompletedLevels": false,
            "EditMode": true
        ])
        
        // Initialize view models (assuming ApplicationViewModel has properties for them)
        let appViewModel = ApplicationViewModel()
        _applicationViewModel = StateObject(wrappedValue: appViewModel)
        _navigationViewModel = StateObject(wrappedValue: appViewModel.navigationViewModel)
        _settingsViewModel = StateObject(wrappedValue: appViewModel.settingsViewModel)
        _stateModel = StateObject(wrappedValue: appViewModel.stateModel)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(applicationViewModel)
                .environmentObject(navigationViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(stateModel)
        }
    }
}
