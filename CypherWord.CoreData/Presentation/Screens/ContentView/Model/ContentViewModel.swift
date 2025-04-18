import Foundation
import Dependencies

final class ContentViewModel: ObservableObject {
    @Published var stateModel: StateModel!
    @Published var isInitialized = false
    @Published var error: String?
    private var importLeveslUseCase: ImportLevelsUseCaseProtocol
    private var loadManifestUseCase: LoadManifestUseCaseProtocol
//    @MainActor
    init(
        stateModel: StateModel,
        importLeveslUseCase: ImportLevelsUseCaseProtocol = ImportLevelsUseCase(playableLevelRepository: Dependency(\.playableLevelRepository).wrappedValue,
                                                                               layoutRepository: Dependency(\.layoutRepository).wrappedValue,
                                                                               fileRepository:  Dependency(\.fileRepository).wrappedValue),
        loadManifestUseCase:LoadManifestUseCaseProtocol = LoadManifestUseCase(levelRepository: Dependency(\.playableLevelRepository).wrappedValue)
    )
    {
        self.stateModel = stateModel
        self.importLeveslUseCase = importLeveslUseCase
        self.loadManifestUseCase = loadManifestUseCase
    }
    
    func start2() {
        isInitialized = false
    }
    

    private func saveLevels(levelType: LevelType, levels: [LevelDefinition]) {
        
    }
    
//    @MainActor
    func start() {

        Task {
            do {
                let manifest = try await loadManifestUseCase.execute()
                try await importLeveslUseCase.execute(fileDefinition: LayoutFileDefinition())
                guard let packDefinition = manifest.getLevelFileDefinition(forNumber: 1) else {
                    fatalError("Can't load manifest")
                }
                let playableFile = PlayableLevelFileDefinition(packDefintion: packDefinition)
                try await importLeveslUseCase.execute(fileDefinition: playableFile)
                stateModel.reloadAll()
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
}
