import Foundation
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
    private let fetchLayoutsUseCase: FetchLevelsUseCaseProtocol
    private let fetchPlayableLevelsUseCase: FetchLevelsUseCaseProtocol
    private let deleteAllLevelstUseCase: DeleteAllLevelsUseCaseProtocol
    private let addLayoutUseCase: AddLayoutUseCaseProtocol

    init(fetchLayoutsUseCase: FetchLevelsUseCaseProtocol,
         fetchPlayableLevelsUseCase: FetchLevelsUseCaseProtocol,
         addLayoutUseCase: AddLayoutUseCaseProtocol,
         deleteAllLevelstUseCase: DeleteAllLevelsUseCaseProtocol
    ) {

        self.fetchLayoutsUseCase = fetchLayoutsUseCase
        self.fetchPlayableLevelsUseCase = fetchPlayableLevelsUseCase
        self.addLayoutUseCase = addLayoutUseCase
        self.deleteAllLevelstUseCase = deleteAllLevelstUseCase

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
        deleteAllLevelstUseCase.execute(levelType: levelType, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let levels):
                        self?.layouts = levels
                    case .failure(let error):
                        self?.error = error.localizedDescription
                }
            }
        })
    }
}
