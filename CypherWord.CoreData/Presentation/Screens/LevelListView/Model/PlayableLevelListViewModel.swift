import SwiftUICore
import Dependencies

class PlayableLevelListViewModel: LevelListViewModel {
//    private var loadManifestUaeCase: LoadManifestUseCaseProtocol
//    private var deleteAllPlayableLevelsUseCase: DeleteAllPlayableLevelsUseCaseProtocol

//    var manifest: Manifest?
    var packNumber: Int = 0
//    {
//        didSet {
//            if (packNumber == stateModel.currentPackNum) { return }
//            stateModel.currentPackNum = packNumber
//        }
//    }
    
    func increasePackNum() {
        stateModel.currentPackNum += 1
    }
    
    func decreasePackNum() {
        stateModel.currentPackNum -= 1
    }

    
//    @Published var packNumber: Int? {
//        didSet {
//            print("Pack number \(String(describing: packNumber))")
////            reload()
//        }
//    }
//
    init(navigationViewModel:NavigationViewModel,
         settingsViewModel: SettingsViewModel,
         stateModel: StateModel
//         deleteAllPlayableLevelsUseCase: DeleteAllPlayableLevelsUseCaseProtocol = DeleteAllPlayableLevelsUseCase(levelRepository: Dependency(\.playableLevelRepository).wrappedValue),
//         loadManifestUseCase: LoadManifestUseCaseProtocol = LoadManifestUseCase(levelRepository: Dependency(\.playableLevelRepository).wrappedValue)
    ){
//        self.loadManifestUaeCase = loadManifestUseCase
//        self.deleteAllPlayableLevelsUseCase = deleteAllPlayableLevelsUseCase
        
//        self.packNumber = nil
//        self.manifest = nil
        
        super.init(navigationViewModel: navigationViewModel,
                   settingsViewModel: settingsViewModel,
                   stateModel: stateModel,
                   levelFile: LevelFile(definition: PlayableLevelFileDefinition(packNumber: nil), levels: []))

        Task {
//            let manifest = try await loadManifestUseCase.execute()
//            self.packNumber = manifest.maxLevelNumber
//            self.manifest = manifest
        }
        
        updateDisplayableLevels(levels: stateModel.playableLevels, showCompleted: settingsViewModel.settings.showCompletedLevels)
        
        stateModel.$playableLevels
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
                self?.updateDisplayableLevels(levels: stateModel.playableLevels, showCompleted: newShowCompleted)
            }
            .store(in: &cancellables)
        
        stateModel.$currentPackNum
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newPackNumber in
                self?.packNumber = newPackNumber
            }
            .store(in: &cancellables)

    }

    
    
    override func title() -> String {
        LevelType.playable.rawValue
    }

    override func primaryColor(level:LevelDefinition? = nil) -> Color {
        if let level = level {
            if level.numCorrectLetters == 26 {
                return .green
            }
        }
        return .blue
    }
    
    override func secondaryColor(level:LevelDefinition? = nil) -> Color {
        if let level = level {
            if level.numCorrectLetters == 26 {
                return .mint
            }
        }
        return .cyan
    }
    
    override var isLayout : Bool {
        get { false }
    }
    
    var maxLevelNumber: Int {
        stateModel.numPacks
//        guard let manifest else { return 0 }
//        
//        return manifest.maxLevelNumber
    }

//    override func reload() {
//        stateModel.reloadPlayableLevels()
//    }
//
    @MainActor
    override func deleteAll() {
        stateModel.deleteAllPlayableLevels()
    }
    
    func updateDisplayableLevels(levels: [LevelDefinition], showCompleted: Bool) {
        objectWillChange.send()
        
        if showCompleted {
            displayableLevels = levels
        }
        else {
            displayableLevels = levels.filter {level in
                return level.percentComplete < 1
            }
        }
    }
    
    override var tag: LevelType {
        get {
            .playable
        }
    }
}
