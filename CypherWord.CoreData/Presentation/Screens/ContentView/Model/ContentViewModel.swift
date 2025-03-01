import Foundation
import Dependencies

final class ContentViewModel: ObservableObject {
    @Published var isInitialized = false
    @Published var error: String?
    private var importLeveslUseCase: ImportLevelsUseCaseProtocol

    @MainActor
    init(
        importLeveslUseCase: ImportLevelsUseCaseProtocol = ImportLevelsUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue,
                                                                               fileRepository:  Dependency(\.fileRepository).wrappedValue)
    )
    {
        self.importLeveslUseCase = importLeveslUseCase
//        start()
    }
    
    func start2() {
        isInitialized = false
    }
    

    private func saveLevels(levelType: LevelType, levels: [LevelDefinition]) {
        
    }
    
    @MainActor
    func start() {
        print("Content View Model start")

        Task {
            do {
                try await loadLevels(levelType: .layout)
                try await loadLevels(levelType: .playable)
                await MainActor.run {
                    isInitialized = true
                }
            }
            catch {
                await MainActor.run {
                    
                    self.error = error.localizedDescription
                    isInitialized = true
                }
            }
        }
    }
    
    
    
//        finally {
//            
//        }

//        loadLevels(levelType: .layout, completion: { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                    case .success:
//                        self?.loadLevels(levelType: .playable, completion: { [weak self] result in
//                            DispatchQueue.main.async {
//                                switch result {
//                                    case .success:
//                                        self?.isInitialized = true
//                                    case .failure(let error):
//                                        self?.error = error.localizedDescription
//                                        self?.isInitialized = true
//                                }
//                            }
//                        })
//
//                    case .failure(let error):
//                        self?.error = error.localizedDescription
//                        self?.isInitialized = true
//                }
//            }
//        })
//    }
    
    
//    func loadLevels(levelType: LevelType, completion: @escaping (Result<Void, any Error>) -> Void) {
//        importLeveslUseCase.execute(levelType: levelType) { /*[weak self]*/ result in
//            DispatchQueue.main.async {
//                switch result {
//                    case .success: 
//                        completion(.success(()))
//                    case .failure(let error):
//                        completion(.failure(error))
//                }
//            }
//        }
//    }
    
    func loadLevels(levelType: LevelType) async throws {
        print("Loading levels... \(levelType)")
        try await importLeveslUseCase.execute(levelType: levelType)
//        importLeveslUseCase.execute(levelType: levelType) { /*[weak self]*/ result in
//            DispatchQueue.main.async {
//                switch result {
//                    case .success:
//                        completion(.success(()))
//                    case .failure(let error):
//                        completion(.failure(error))
//                }
//            }
//        }
    }

}
