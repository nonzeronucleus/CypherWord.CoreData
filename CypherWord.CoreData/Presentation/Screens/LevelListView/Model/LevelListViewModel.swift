import Foundation
import SwiftUI
import Dependencies
import Combine


class LevelListViewModel: ObservableObject {
    @Published var levels: [Level] = []
    @Published var layouts: [Level] = []
    @Published var error:String?
    @Dependency(\.importLevelsUseCase) private var importLeveslUseCase: ImportLevelsUseCaseProtocol

//    @Published var path: [String] = []
//    var path: NavigationPath {
//        get {
//            return navigationViewModel.path
//        }
//        set {
//            navigationViewModel.path = newValue
//        }
//    }

    @Published private(set) var selectedLayout: Level?
    @Published private(set) var selectedPlayableLevel: Level?
    var navigationViewModel: NavigationViewModel?
    
    @Published var selectedLevelID: UUID? {
        didSet {
            updateSelectedLevel()
        }
    }
    
    @Published var showDetail: Bool = false


    
    private var cancellables = Set<AnyCancellable>()
    @Dependency(\.fetchLayoutsUseCase) private var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol
    @Dependency(\.fetchPlayableLevelsUseCase) private var fetchPlayableLevelsUseCase: FetchLevelsUseCaseProtocol
    @Dependency(\.deleteAllLevelsUseCase) private var deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol
    @Dependency(\.addLayoutUseCase) private var addLayoutUseCase: AddLayoutUseCaseProtocol

    init(navigationViewModel:NavigationViewModel){
        self.navigationViewModel = navigationViewModel
        start()
    }
    
    func reload() {
        fetchLevels()
        fetchLayouts()
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
                    self?.layouts = levels
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
                        self?.layouts = levels
                    case .failure(let error):
                        self?.error = error.localizedDescription
                }
            }
        }
    }

    func deleteAll(levelType: Level.LevelType) {
        deleteAllLevelsUseCase.execute(levelType: levelType, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let levels):
                        switch levelType {
                            case .playable:
                                self?.levels = levels
                            case .layout:
                                self?.layouts = levels
                        }
                        
                    case .failure(let error):
                        self?.error = error.localizedDescription
                }
            }
        })
    }
    
    func updateSelectedLevel() {
        
        
//        if let navigationViewModel  {
//            selectedLayout = layouts.first(where: { $0.id == selectedLevelID })
//            navigationViewModel.navigateTo(.edit)
//            print("\(String(describing: selectedLayout))")
//            if selectedLayout == nil {
//                selectedPlayableLevel = levels.first(where: { $0.id == selectedLevelID })
//                navigationViewModel.navigateTo(.game)
//            }
//            showDetail = selectedLayout != nil || selectedPlayableLevel != nil
//        }
    }
    
    func onSelectLevel(level:Level) {
        navigationViewModel?.navigateTo(level:level)
//        selectedLevelID = id
//        print(id)
    }
    
    func start() {
        loadLevels(levelType: .layout, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success:
                        self?.loadLevels(levelType: .playable, completion: { [weak self] result in
                            DispatchQueue.main.async {
                                switch result {
                                    case .success:
//                                        self?.isInitialized = true
                                        self?.reload()
                                    case .failure(let error):
                                        self?.error = error.localizedDescription
//                                        self?.isInitialized = true
                                }
                            }
                        })

                    case .failure(let error):
                        self?.error = error.localizedDescription
//                        self?.isInitialized = true
                }
            }
        })
//        isInitialized = true
    }
    
    
    func loadLevels(levelType: Level.LevelType, completion: @escaping (Result<Void, any Error>) -> Void) {
        importLeveslUseCase.execute(levelType: levelType) { /*[weak self]*/ result in
            DispatchQueue.main.async {
                switch result {
                    case .success: //(let levels):
//                        self?.saveLevels(levelType: levelType, levels: levels)
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
    
    
}
