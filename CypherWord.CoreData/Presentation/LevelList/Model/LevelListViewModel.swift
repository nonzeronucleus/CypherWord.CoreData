import Foundation
import Combine


class LevelListViewModel: LevelListViewModelProtocol {
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
        super.init()

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

    
    override func addLayout() {
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

    override func deleteAll(levelType: Level.LevelType) {
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
    
    func onCellClick(uuid:UUID) {
        print("\(uuid)")
//        if completed {
//            return
//        }
//        
//        checking = false
        
//        let cell = crossword.findElement(byID: uuid)
//        
//        if let cell = cell {
//            if let letter = cell.letter {
//                if let number = letterValues?[letter] {
//                    selectedNumber = number
//                }
//            }
//        }
    }
    
//    private func updateSelectedLevel() {
//        selectedLevel = layouts.first(where: { $0.id == selectedLevelID })
//        showDetail = selectedLevel != nil
//    }
}
