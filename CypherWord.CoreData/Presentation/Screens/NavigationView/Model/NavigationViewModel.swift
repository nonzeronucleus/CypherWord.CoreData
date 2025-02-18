import SwiftUI
import Dependencies


class NavigationViewModel: ObservableObject {
    @Dependency(\.fetchLevelByIDUseCase) private var fetchLevelByIDUseCase: FetchLevelByIDUseCaseProtocol

    @Published var path: NavigationPath = NavigationPath()
    @Published var error: Error?
    
    var level: LevelDefinition? = nil
    
    func navigateTo(level:LevelDefinition) {
        self.level = level
        path.append(level.levelType)
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
        return GameViewModel(level: level!, navigationViewModel: self)
    }

    func createLayoutViewModel() -> LevelEditViewModel {
        return LevelEditViewModel(levelDefinition: level!, navigationViewModel: self)
    }
    
}

enum Destination: Hashable {
    case edit
    case game
}
