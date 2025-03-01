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
    }
    
    func start2() {
        isInitialized = false
    }
    

    private func saveLevels(levelType: LevelType, levels: [LevelDefinition]) {
        
    }
    
    @MainActor
    func start() {

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
    
    
    func loadLevels(levelType: LevelType) async throws {
        try await importLeveslUseCase.execute(levelType: levelType)
    }
}
