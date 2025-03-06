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
                try await loadLevels(fileDefinition: LayoutFileDefinition())
                try await loadLevels(fileDefinition: PlayableLevelFileDefinition(packNumber: 1))
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
    
    
    func loadLevels(fileDefinition: FileDefinitionProtocol) async throws {
//        print("Need to implement \(#function) in \(#file)")
        try await importLeveslUseCase.execute(fileDefinition: fileDefinition)
            
//            .execute(
//            levelType: levelType, packNumber: 1)
//        )
    }
}
