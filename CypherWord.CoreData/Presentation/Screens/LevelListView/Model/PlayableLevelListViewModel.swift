import SwiftUICore
import Dependencies

class PlayableLevelListViewModel: LevelListViewModel {
    private var fetchPlayableLevelsUseCase: FetchLevelsUseCaseProtocol
    private var loadManifestUaeCase: LoadManifestUseCaseProtocol
    var manifest: Manifest?
    @Published var packNumber: Int? {
        didSet {
            print("Pack number \(String(describing: packNumber))")
        }
    }

    init(navigationViewModel:NavigationViewModel,
         settingsViewModel: SettingsViewModel,
         fetchPlayableLevelsUseCase: FetchLevelsUseCaseProtocol = FetchPlayableLevelsUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue),
         loadManifestUseCase: LoadManifestUseCaseProtocol = LoadManifestUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue)
    ){
        self.loadManifestUaeCase = loadManifestUseCase
//        let initPackNumber: Int = 1
        self.fetchPlayableLevelsUseCase = fetchPlayableLevelsUseCase
        
        self.packNumber = nil
        self.manifest = nil
        
        super.init(navigationViewModel: navigationViewModel,
                   settingsViewModel: settingsViewModel,
                   levelFile: LevelFile(definition: PlayableLevelFileDefinition(packNumber: nil), levels: []))

        Task {
            let manifest = try await loadManifestUseCase.execute()
            self.packNumber = manifest.maxLevelNumber
            self.manifest = manifest
        }
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
        guard let manifest else { return 0 }
        
        return manifest.maxLevelNumber
    }

    override func reload() {
        Task {
            do {
                let levels = try await self.fetchPlayableLevelsUseCase.execute()
                await MainActor.run {
//                    self.allLevels = levels  // ✅ Runs on main thread
                    levelFile.levels = levels
                    
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription  // ✅ Also ensure error updates on main thread
                }
            }
        }
    }

    @MainActor
    override func deleteAll() {
        Task {
            do {
                let levels = try await deleteAllLevelsUseCase.execute(levelType: .playable)
                await MainActor.run {
                    levelFile.levels = levels  // ✅ Ensures update happens on the main thread
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription  // ✅ Ensures error updates on main thread
                }
            }
        }
    }
    
    override func updateDisplayableLevels(levels: [LevelDefinition], showCompleted: Bool) {
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
