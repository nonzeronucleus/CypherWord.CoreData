import Foundation
import SwiftUI
import Dependencies
import Combine

@MainActor
class LevelListViewModel: ObservableObject {
    var settingsViewModel: SettingsViewModel
    var exportPlayableLevelsUseCase: ExportLevelsUseCaseProtocol
    var stateModel: StateModel
    
//    @Published var levelFile: LevelFile
    @Published var displayableLevels: [LevelDefinition] = []
    @Published var error:String?
    @Published private(set) var selectedLevel: LevelDefinition?
    @Published var isBusy: Bool = false
    
    @Published var showCompleted: Bool = false
    
    private var navigationViewModel: NavigationViewModel?
    var cancellables = Set<AnyCancellable>()
    
    @MainActor
    init(navigationViewModel:NavigationViewModel,
         settingsViewModel: SettingsViewModel,
         stateModel: StateModel,
//         levelFile: LevelFile,
         exportPlayableLevelsUseCase: ExportLevelsUseCaseProtocol = ExportLevelsUseCase(fileRepository: Dependency(\.fileRepository).wrappedValue)
    ){
        self.navigationViewModel = navigationViewModel
        self.settingsViewModel = settingsViewModel
        self.stateModel = stateModel
//        self.levelFile = levelFile
        self.exportPlayableLevelsUseCase = exportPlayableLevelsUseCase
        
        showCompleted = settingsViewModel.settings.showCompletedLevels
        
//        reload()
    }
    
    

    
    func onSelectLevel(level:LevelDefinition) {
        navigationViewModel?.navigateTo(level:level)
    }
    

    
    func navigateToSettings() {
        navigationViewModel?.navigateToSettings()
    }
    
    
    // Level type-specific funcs
        
//    func updateDisplayableLevels(levels: [LevelDefinition], showCompleted: Bool) {
//        fatalError("\(String(describing: #function)) not implemented")
//    }

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
    
//    @MainActor
//    func reload() {
//        fatalError("\(String(describing: #function)) not implemented")
//    }
//    
    func exportAll() {
//        self.displayableLevels = stateModel.layouts

//        isBusy = true
//        
//        Task {
//            do {
//                try await exportPlayableLevelsUseCase.execute(file: levelFile)
//                await MainActor.run {
//                    
//                    isBusy = false
//                }
//            } catch {
//                await MainActor.run {
//                    
//                    self.error = error.localizedDescription
//                    isBusy = false
//                }
//            }
//        }
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
