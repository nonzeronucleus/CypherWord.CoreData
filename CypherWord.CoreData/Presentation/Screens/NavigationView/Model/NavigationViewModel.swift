import SwiftUI
import Dependencies


enum NavigationDestination {
    case detail
    case settings
}

class NavigationViewModel: ObservableObject {
    private var fetchLevelByIDUseCase: FetchLevelByIDUseCaseProtocol
    @Published var path: NavigationPath = NavigationPath()
    @Published var error: Error?
    
    init(fetchLevelByIDUseCase: FetchLevelByIDUseCaseProtocol = FetchLevelByIDUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue))
    {
        self.fetchLevelByIDUseCase = fetchLevelByIDUseCase
    }
    
    var level: LevelDefinition? = nil
    
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
    
    func createLevelListViewModel(levelType: LevelType) -> LevelListViewModel {
        LevelListViewModel(navigationViewModel: self, levelType: levelType)
    }
    
    func createSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel()
    }
    
}

enum Destination: Hashable {
    case edit
    case game
}
