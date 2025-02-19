import Foundation
import SwiftUI
import Dependencies
import Combine


class LevelListViewModel: ObservableObject {
    @Dependency(\.importLevelsUseCase) private var importLeveslUseCase: ImportLevelsUseCaseProtocol
    @Dependency(\.fetchLayoutsUseCase) private var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol
    @Dependency(\.fetchPlayableLevelsUseCase) private var fetchPlayableLevelsUseCase: FetchLevelsUseCaseProtocol
    @Dependency(\.deleteAllLevelsUseCase) private var deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol
    @Dependency(\.addLayoutUseCase) private var addLayoutUseCase: AddLayoutUseCaseProtocol
    @Dependency(\.exportAllUseCase) private var exportAllUseCase: ExportAllUseCaseProtocol

    @Published var allLevels: [LevelDefinition] = []
    @Published var displayableLevels: [LevelDefinition] = []
    @Published var error:String?
    @Published private(set) var selectedLevel: LevelDefinition?
    @Published var levelType: LevelType
    @Published var isBusy: Bool = false
    
    @Published var showCompleted: Bool = false

    private var navigationViewModel: NavigationViewModel?
    private var cancellables = Set<AnyCancellable>()

    init(navigationViewModel:NavigationViewModel, levelType: LevelType){
        self.navigationViewModel = navigationViewModel
        self.levelType = levelType
        
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
    
    func reload() {
        switch levelType {
            case .layout:
                fetchLayouts()
            case .playable:
                fetchLevels()
        }
    }
    
    func updateDisplayableLevels(levels: [LevelDefinition], showCompleted: Bool) {
        objectWillChange.send()
        
        displayableLevels = levels.filter {
            switch levelType {
                case .layout:
                    return true
                case .playable:
                    if (self.showCompleted) {
                        return true
                    }
                    return $0.percentComplete < 1
            }
        }
    }
    

    func fetchLevels() {
        fetchPlayableLevelsUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let levels):
                    self?.allLevels = levels
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }

        
    func fetchLayouts() {
        fetchLayoutsUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let levels):
                    self?.allLevels = levels
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }

    
    func addLayout() {
        addLayoutUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let levels):
                        self?.allLevels = levels
                    case .failure(let error):
                        self?.error = error.localizedDescription
                }
            }
        }
    }

    func deleteAll() {
        deleteAllLevelsUseCase.execute(levelType: levelType, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let levels):
                        self?.allLevels = levels
                    case .failure(let error):
                        self?.error = error.localizedDescription
                }
            }
        })
    }
    
    func onSelectLevel(level:LevelDefinition) {
        navigationViewModel?.navigateTo(level:level)
    }
    
    func exportAll() {
        isBusy = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            exportAllUseCase.execute(levels: allLevels, completion:  { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                        case .success():
                            self?.isBusy = false
                        case .failure(let error):
                            self?.error = error.localizedDescription
                            self?.isBusy = false
                    }
                }
            })
        }
    }
}
