import Foundation
import SwiftUI
import Dependencies
import Combine

@MainActor
class LevelListViewModel: ObservableObject {
    var settingsViewModel: SettingsViewModel
    
    var deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol
    
    @Published var allLevels: [LevelDefinition] = []
    @Published var displayableLevels: [LevelDefinition] = []
    @Published var error:String?
    @Published private(set) var selectedLevel: LevelDefinition?
    @Published var isBusy: Bool = false
    
    @Published var showCompleted: Bool = false
    
    private var navigationViewModel: NavigationViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    init(navigationViewModel:NavigationViewModel,
         settingsViewModel: SettingsViewModel,
         deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol = DeleteAllLevelsUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue)
    ){
        self.navigationViewModel = navigationViewModel
        self.settingsViewModel = settingsViewModel
        self.deleteAllLevelsUseCase = deleteAllLevelsUseCase
        
        showCompleted = settingsViewModel.settings.showCompletedLevels
        
        $allLevels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLevels in
                if let showCompleted = self?.showCompleted {
                    self?.updateDisplayableLevels(levels: newLevels, showCompleted: showCompleted)
                }
            }
            .store(in: &cancellables)
        
        $showCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newShowCompleted in
                if let levels = self?.allLevels {
                    self?.updateDisplayableLevels(levels: levels, showCompleted: newShowCompleted)
                }
            }
            .store(in: &cancellables)
        
        reload()
    }
    
    

    
    func onSelectLevel(level:LevelDefinition) {
        navigationViewModel?.navigateTo(level:level)
    }
    

    
    func navigateToSettings() {
        navigationViewModel?.navigateToSettings()
    }
    
    
    // Level type-specific funcs
        
    func updateDisplayableLevels(levels: [LevelDefinition], showCompleted: Bool) {
        fatalError("\(String(describing: #function)) not implemented")
    }

    func title() -> String {
        fatalError("\(String(describing: #function)) not implemented")
    }

    func primaryColor(level:LevelDefinition? = nil) -> Color {
        fatalError("\(String(describing: #function)) not implemented")
    }

    func secondaryColor(level:LevelDefinition? = nil) -> Color {
        fatalError("\(String(describing: #function)) not implemented")
    }
    
    var isLayout : Bool {
        get {
            fatalError("\(String(describing: #function)) not implemented")
        }
    }
    
    @MainActor
    func reload() {
        fatalError("\(String(describing: #function)) not implemented")
    }
    
    func exportAll() {
        fatalError("\(String(describing: #function)) not implemented")
    }
    
    @MainActor
    func deleteAll() {
        fatalError("\(String(describing: #function)) not implemented")
    }
    
    var tag: LevelType {
        get {
            fatalError("\(String(describing: #function)) not implemented")
        }
    }
}
