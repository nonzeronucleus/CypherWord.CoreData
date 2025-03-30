import Foundation
import Dependencies

class StateModel: ObservableObject {
    private var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol
    private var fetchPlayableLevelsUseCase: FetchPlayableLevelsUseCaseProtocol
    private var loadManifestUaeCase: LoadManifestUseCaseProtocol
    private var deleteAllLayoutsUseCase: DeleteAllLayoutsUseCaseProtocol
    private var deleteAllPlayableLevelsUseCase: DeleteAllPlayableLevelsUseCaseProtocol
    
    init(
        fetchLayoutsUseCase: FetchLevelsUseCaseProtocol = FetchLayoutsUseCase(levelRepository: Dependency(\.layoutRepository).wrappedValue),
        fetchPlayableLevelsUseCase: FetchPlayableLevelsUseCaseProtocol = FetchPlayableLevelsUseCase(levelRepository: Dependency(\.playableLevelRepository).wrappedValue),
        loadManifestUseCase: LoadManifestUseCaseProtocol = LoadManifestUseCase(levelRepository: Dependency(\.playableLevelRepository).wrappedValue),
        deleteAllLayoutsUseCase: DeleteAllLayoutsUseCaseProtocol = DeleteAllLayoutsUseCase(levelRepository: Dependency(\.layoutRepository).wrappedValue),
        deleteAllPlayableLevelsUseCase: DeleteAllPlayableLevelsUseCaseProtocol = DeleteAllPlayableLevelsUseCase(levelRepository: Dependency(\.playableLevelRepository).wrappedValue)
    ) {
        self.fetchLayoutsUseCase = fetchLayoutsUseCase
        self.fetchPlayableLevelsUseCase = fetchPlayableLevelsUseCase
        self.loadManifestUaeCase = loadManifestUseCase
        self.deleteAllLayoutsUseCase = deleteAllLayoutsUseCase
        self.deleteAllPlayableLevelsUseCase = deleteAllPlayableLevelsUseCase
        
        reloadAll()
    }
    
    @Published var currentPackNum: Int = 1 {
        didSet {
            print("currentPackNum didSet")
            loadPlayableLevels()
        }
    }
    
    @Published var playableLevels: [LevelDefinition] = []
    @Published var layouts: [LevelDefinition] = []
    var manifest: Manifest = Manifest(levels: [])
    
    func reloadPlayableLevels() {
        print("reloadPlayableLevels")
        loadPlayableLevels()
    }
    
    func reloadAll() {
        print("Reload all")
        loadManifest()
        loadLayouts()
        loadPlayableLevels()
    }
    
    func deleteAllLayouts() {
        deleteAllLayoutsInternal()
    }
    
    func deleteAllPlayableLevels() {
        deleteAllPlayableLevelsInternal()
    }
    
    var numPacks: Int {
        get {
            return manifest.fileDefinitions.count
        }
    }
}


// Layouts

extension StateModel {
    private func loadLayouts() {
        Task {
            do {
                let layouts = try await fetchLayoutsUseCase.execute()
                await MainActor.run {
                    self.layouts = layouts  // ✅ Runs on Main Thread
                }
            } catch {
                print("Error fetching layouts: \(error)")
            }
        }
    }
    
    private func deleteAllLayoutsInternal() {
        Task {
            do {
                let layouts = try await deleteAllLayoutsUseCase.execute()
                await MainActor.run {
                    self.layouts = layouts
                }
            } catch {
                print("Error deleting layouts: \(error)")
            }
        }
    }
}



// Playable levels

extension StateModel {
    private func loadManifest() {
        Task {
            do {
                print("Loading manifest")
                let manifest = try await loadManifestUaeCase.execute()
                await MainActor.run {
                    self.manifest = manifest
                }
            }
        }
    }
    
    private func loadPlayableLevels() {
        Task {
            do {
                print("Loading playable levels")
                let playableLevels = try await fetchPlayableLevelsUseCase.execute(packNum: currentPackNum)
                
                await MainActor.run {
                    self.playableLevels = playableLevels  // ✅ Runs on Main Thread
                }
            }
            catch {
                print("Error fetching playable levels: \(error)")
            }
        }
    }
    
    func deleteAllPlayableLevelsInternal() {
        Task {
            do {
                let playableLevels = try await deleteAllPlayableLevelsUseCase.execute(packNum: currentPackNum)
                await MainActor.run {
                    self.playableLevels = playableLevels
                }
            } catch {
                print("Error deleting playable levels: \(error)")
            }
        }
    }
}



