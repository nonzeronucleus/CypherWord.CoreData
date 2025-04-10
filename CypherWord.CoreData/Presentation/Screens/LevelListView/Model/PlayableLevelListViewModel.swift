import SwiftUICore
import Dependencies

class PlayableLevelListViewModel: LevelListViewModel {
    var packNumber: Int {
        get {
            guard let currentPack = stateModel.currentPack else {
                return 0
            }

            return currentPack.packNumber ?? 0
        }
    }
    
    func increasePackNum() {
        stateModel.loadNextPack()
    }
    
    func decreasePackNum() {
        stateModel.loadPreviousPack()
    }

    
    init(navigationViewModel:NavigationViewModel,
         settingsViewModel: SettingsViewModel,
         stateModel: StateModel
    ){
        
        super.init(navigationViewModel: navigationViewModel,
                   settingsViewModel: settingsViewModel,
                   stateModel: stateModel)

        updateDisplayableLevels(levels: stateModel.playableLevels, showCompleted: settingsViewModel.settings.showCompletedLevels)
        
        stateModel.$playableLevels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLevels in
                print("Loaded new playable levels \(newLevels.count)")
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
    }

//    @MainActor
    override func deleteAll() {
        stateModel.deleteAllPlayableLevels()
        stateModel.reloadAll()
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
    
    override func exportAll() {
        guard let currentPack = stateModel.currentPack else { return }
        
        let levelFile = LevelFile(definition: PlayableLevelFileDefinition(packDefintion: currentPack), levels: stateModel.playableLevels)
        
//        self.displayableLevels = stateModel.layouts

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
    
    override var tag: LevelType {
        get {
            .playable
        }
    }
}
