import Foundation
import Dependencies

final class ContentViewModel: ObservableObject {
    @Published var isInitialized = false
    @Published var error: String?
    private var importLeveslUseCase: ImportLevelsUseCaseProtocol

    init(
        importLeveslUseCase: ImportLevelsUseCaseProtocol = ImportLevelsUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue,
                                                                               fileRepository:  Dependency(\.fileRepository).wrappedValue)
    )
    {
        self.importLeveslUseCase = importLeveslUseCase
        start()
    }
    
    func start2() {
        isInitialized = false
    }
    

    private func saveLevels(levelType: LevelType, levels: [LevelDefinition]) {
        
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
                                        self?.isInitialized = true
                                    case .failure(let error):
                                        self?.error = error.localizedDescription
                                        self?.isInitialized = true
                                }
                            }
                        })

                    case .failure(let error):
                        self?.error = error.localizedDescription
                        self?.isInitialized = true
                }
            }
        })
    }
    
    
    func loadLevels(levelType: LevelType, completion: @escaping (Result<Void, any Error>) -> Void) {
        importLeveslUseCase.execute(levelType: levelType) { /*[weak self]*/ result in
            DispatchQueue.main.async {
                switch result {
                    case .success: 
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
}
