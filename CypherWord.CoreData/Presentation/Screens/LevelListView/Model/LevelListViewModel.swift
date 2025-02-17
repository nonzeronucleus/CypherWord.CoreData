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

    @Published var levels: [LevelDefinition] = []
    @Published var error:String?
    @Published private(set) var selectedLevel: LevelDefinition?
    @Published var levelType: LevelType
    @Published var isBusy: Bool = false

    private var navigationViewModel: NavigationViewModel?
    private var cancellables = Set<AnyCancellable>()

    init(navigationViewModel:NavigationViewModel, levelType: LevelType){
        self.navigationViewModel = navigationViewModel
        self.levelType = levelType
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
    

    func fetchLevels() {
        fetchPlayableLevelsUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let levels):
                    self?.levels = levels
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
                    self?.levels = levels
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
                        self?.levels = levels
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
                        self?.levels = levels
//                        switch self?.levelType {
//                            case .playable:
//                                self?.levels = levels
//                            case .layout:
//                                self?.levels = levels
//                            case .none:
//                                break
//                        }
                        
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
            
            exportAllUseCase.execute(levels: levels, completion:  { [weak self] result in
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
