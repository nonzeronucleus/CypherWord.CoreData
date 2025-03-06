import SwiftUICore
import Dependencies

class LayoutListViewModel: LevelListViewModel {
    
    private var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol
    private var addLayoutUseCase: AddLayoutUseCaseProtocol
    private var exportLayoutsUseCase: ExportLevelsUseCaseProtocol
    
    init(navigationViewModel:NavigationViewModel,
         settingsViewModel: SettingsViewModel,
         fetchLayoutsUseCase: FetchLevelsUseCaseProtocol = FetchLayoutsUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue),
         addLayoutUseCase: AddLayoutUseCaseProtocol = AddLayoutUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue),
         exportLayoutsUseCase:ExportLevelsUseCaseProtocol = ExportLevelsUseCase(fileRepository: Dependency(\.fileRepository).wrappedValue)
    ){
        self.fetchLayoutsUseCase = fetchLayoutsUseCase
        self.addLayoutUseCase = addLayoutUseCase
        self.exportLayoutsUseCase = exportLayoutsUseCase

        super.init(navigationViewModel: navigationViewModel, settingsViewModel: settingsViewModel)
    }

    
    
    override func title() -> String {
        LevelType.layout.rawValue
    }
    
    override func primaryColor(level:LevelDefinition? = nil) -> Color {
        return .orange
    }
    
    override func secondaryColor(level:LevelDefinition? = nil) -> Color {
        return .red
    }
    
//    override func isLayout() -> Bool {
    override var isLayout : Bool {
        get { true }
    }
    
    @MainActor
    override func reload() {
        Task {
            do {
                let levels = try await self.fetchLayoutsUseCase.execute()
                await MainActor.run {
                    self.allLevels = levels  // ✅ Runs on main thread
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription  // ✅ Also ensure error updates on main thread
                }
            }
        }
    }
    
    func addLayout() {
        Task {
            allLevels = try await addLayoutUseCase.execute()
        }
    }
    
    override func exportAll() {
        isBusy = true
        
        Task {
            do {
                try await exportLayoutsUseCase.execute(fileDefinition: LayoutFileDefinition(), levels: allLevels) 
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
    override func deleteAll() {
        Task {
            do {
                let levels = try await deleteAllLevelsUseCase.execute(levelType: .layout)
                await MainActor.run {
                    self.allLevels = levels  // ✅ Ensures update happens on the main thread
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription  // ✅ Ensures error updates on main thread
                }
            }
        }
    }
    
    override func updateDisplayableLevels(levels: [LevelDefinition], showCompleted: Bool) {
        displayableLevels = levels
    }
    
    override var tag: LevelType {
        get {
            .layout
        }
    }
}
