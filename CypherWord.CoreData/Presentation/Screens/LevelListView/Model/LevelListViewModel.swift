import Foundation
import Dependencies
import Combine


class LevelListViewModel: ObservableObject {
    @Published var levels: [Level] = []
    @Published var layouts: [Level] = []
    @Published var error:String?
    
    @Published private(set) var selectedLevel: Level?
    
    @Published var selectedLevelID: UUID? {
        didSet {
            updateSelectedLevel()
        }
    }
    
    @Published var showDetail: Bool = false

    func updateSelectedLevel() {
        selectedLevel = layouts.first(where: { $0.id == selectedLevelID })
        showDetail = selectedLevel != nil
    }
    
    private var cancellables = Set<AnyCancellable>()
    @Dependency(\.fetchLayoutsUseCase) private var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol
    @Dependency(\.fetchPlayableLevelsUseCase) private var fetchPlayableLevelsUseCase: FetchLevelsUseCaseProtocol
    @Dependency(\.deleteAllLevelsUseCase) private var deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol
    @Dependency(\.addLayoutUseCase) private var addLayoutUseCase: AddLayoutUseCaseProtocol

    init(){
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
}
