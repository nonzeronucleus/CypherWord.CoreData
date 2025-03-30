import SwiftUICore
import Dependencies

class LayoutListViewModel: LevelListViewModel {
    private var addLayoutUseCase: AddLayoutUseCaseProtocol
    private var exportLayoutsUseCase: ExportLevelsUseCaseProtocol
    private var deleteAllLayoutsUseCase: DeleteAllLayoutsUseCaseProtocol

    init(navigationViewModel:NavigationViewModel,
         settingsViewModel: SettingsViewModel,
         stateModel: StateModel,
         addLayoutUseCase: AddLayoutUseCaseProtocol = AddLayoutUseCase(levelRepository: Dependency(\.layoutRepository).wrappedValue),
         deleteAllLayoutsUseCase: DeleteAllLayoutsUseCaseProtocol = DeleteAllLayoutsUseCase(levelRepository: Dependency(\.layoutRepository).wrappedValue),
         exportLayoutsUseCase:ExportLevelsUseCaseProtocol = ExportLevelsUseCase(fileRepository: Dependency(\.fileRepository).wrappedValue)
    ){
        self.addLayoutUseCase = addLayoutUseCase
        self.exportLayoutsUseCase = exportLayoutsUseCase
        self.deleteAllLayoutsUseCase = deleteAllLayoutsUseCase

        super.init(navigationViewModel: navigationViewModel,
                   settingsViewModel: settingsViewModel,
                   stateModel: stateModel,
                   levelFile: LevelFile(definition: LayoutFileDefinition(), levels: []))
        
        self.displayableLevels = stateModel.layouts
        
        stateModel.$layouts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLevels in
                self?.displayableLevels = newLevels
            }
            .store(in: &cancellables)

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
    
    override var isLayout : Bool {
        get { true }
    }
    
//    @MainActor
//    override func reload() {
//        stateModel.reloadAll()
//    }
//    
    func addLayout() {
        Task {
            levelFile.levels = try await addLayoutUseCase.execute()
        }
    }
    
    override func exportAll() {
        self.displayableLevels = stateModel.layouts

//        isBusy = true
//        
//        Task {
//            do {
////                let file = LevelFile(definition: DummyFileDefinition(), levels: allLevels)
//
//                try await exportLayoutsUseCase.execute(/*fileDefinition: LayoutFileDefinition(),*/ file: levelFile)
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
    override func deleteAll() {
        stateModel.deleteAllLayouts()
    }

    override var tag: LevelType {
        get {
            .layout
        }
    }
}
