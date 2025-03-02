import SwiftUI
import Dependencies


enum NavigationDestination {
    case detail
    case settings
}

@MainActor
class NavigationViewModel: ObservableObject {
    var settingsViewModel: SettingsViewModel
    private var fetchLevelByIDUseCase: FetchLevelByIDUseCaseProtocol
    
    @Published var path: NavigationPath = NavigationPath()
    @Published var error: Error?
    var level: LevelDefinition? = nil
    
    
    init(
        settingsViewModel: SettingsViewModel,
        fetchLevelByIDUseCase: FetchLevelByIDUseCaseProtocol = FetchLevelByIDUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue)
   )
    {
        self.settingsViewModel = settingsViewModel
        self.fetchLevelByIDUseCase = fetchLevelByIDUseCase
    }
    
    func navigateTo(level:LevelDefinition) {
        self.level = level
        path.append(NavigationDestination.detail)
    }
    
    func navigateToSettings() {
        path.append(NavigationDestination.settings)
    }

    func goBack() {
        if !path.isEmpty {
            path.removeLast()
            level = nil
        }
    }

    func resetNavigation() {
        path = NavigationPath()
    }

    @MainActor
    func createGameViewModel() -> GameViewModel {
        guard let level else {
            fatalError(#function + ": level not set")
        }
        return GameViewModel(level: level, navigationViewModel: self)
    }

    func createLayoutViewModel() -> LevelEditViewModel {
        guard let level else {
            fatalError(#function + ": level not set")
        }
        return LevelEditViewModel(levelDefinition: level, navigationViewModel: self)
    }
    
    @MainActor
    func createLevelListViewModel(levelType: LevelType) -> LevelListViewModel {
        LevelListViewModel(levelType: levelType, navigationViewModel: self, settingsViewModel: settingsViewModel)
    }
}

enum Destination: Hashable {
    case edit
    case game
}
