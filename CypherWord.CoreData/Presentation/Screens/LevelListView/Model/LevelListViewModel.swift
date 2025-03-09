import Foundation
import SwiftUI
import Dependencies
import Combine

@MainActor
class LevelListViewModel: ObservableObject {
    var settingsViewModel: SettingsViewModel
    
    var deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol
    var exportPlayableLevelsUseCase: ExportLevelsUseCaseProtocol
    
//    @Published var allLevels: [LevelDefinition] = []
    @Published var levelFile: LevelFile
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
         levelFile: LevelFile,
         deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol = DeleteAllLevelsUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue),
         exportPlayableLevelsUseCase: ExportLevelsUseCaseProtocol = ExportLevelsUseCase(fileRepository: Dependency(\.fileRepository).wrappedValue)
    ){
        self.navigationViewModel = navigationViewModel
        self.settingsViewModel = settingsViewModel
        self.levelFile = levelFile
        self.deleteAllLevelsUseCase = deleteAllLevelsUseCase
        self.exportPlayableLevelsUseCase = exportPlayableLevelsUseCase
        
        showCompleted = settingsViewModel.settings.showCompletedLevels
        
        levelFile.$levels
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
                self?.updateDisplayableLevels(levels: levelFile.levels, showCompleted: newShowCompleted)
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
        isBusy = true
        
        Task {
            do {
                try await exportPlayableLevelsUseCase.execute(file: levelFile)
                await MainActor.run {
                    
                    isBusy = false
                }
            } catch {
                await MainActor.run {
                    
                    self.error = error.localizedDescription
                    isBusy = false
                }
            }
        }
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
