import Foundation
import Combine
import Dependencies

class StateModel: ObservableObject {
    private var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol
    private var fetchPlayableLevelsUseCase: FetchPlayableLevelsUseCaseProtocol
    private var loadManifestUaeCase: LoadManifestUseCaseProtocol
    private var deleteAllLayoutsUseCase: DeleteAllLayoutsUseCaseProtocol
    private var deleteAllPlayableLevelsUseCase: DeleteAllPlayableLevelsUseCaseProtocol
    var cancellables = Set<AnyCancellable>()

//    @Published var currentPack: PlayableLevelFileDefinition?
    @Published var currentPack: PackDefinition?

    @Published var playableLevels: [LevelDefinition] = []
    @Published var layouts: [LevelDefinition] = []
    var manifest: Manifest = Manifest(levels: [])
    

    
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
        
        self.currentPack = nil
        
        $currentPack
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLevels in
                self?.reloadPlayableLevels()
            }
            .store(in: &cancellables)
        
        loadManifest()
                
        reloadAll()
    }
    func reloadPlayableLevels() {
        loadPlayableLevels()
    }
    
    func reloadAll() {
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
        Task { //@MainActor in
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
        Task { //@MainActor in
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
        Task { //@MainActor in
            do {
                print("Loading manifest")
                let manifest = try await loadManifestUaeCase.execute()
                await MainActor.run {
                    self.manifest = manifest
                    if let firstLevel = manifest.getLevelFileDefinition(forNumber: 1) {
                        currentPack = firstLevel
//                        reloadAll()
                    }
                }
            }
        }
    }
    
    func loadCurrentPackLevels() {
        
    }
    
    func loadNextPack() {
        guard let currentPack else { return }
        
        guard let nextPack = manifest.getNextPack(currentPack: currentPack) else { return }
        
        self.currentPack = nextPack
        loadPlayableLevels()
    }
    
    func loadPreviousPack() {
        guard let currentPack else { return }
        
        guard let nextPack = manifest.getPreviousPack(currentPack: currentPack) else { return }
        
        self.currentPack = nextPack
        loadPlayableLevels()
    }
    
//    private func loadPlayableLevels() {
//        guard let currentPack = currentPack else {
//            return
//        }
//        
//        guard let currentPackNum = currentPack.packNumber else {
//            print("Current Pack not yet set")
//            return
//        }
//        do {
//            let playableLevels = try await fetchPlayableLevelsUseCase.execute(packNum: currentPackNum)
//            
//            await MainActor.run {
//                self.playableLevels = playableLevels  // ✅ Runs on Main Thread
//                print("Full")
//
//            }
//        }
//        catch {
//            print("Error fetching playable levels: \(error)")
//        }
//    }
    
    private func loadPlayableLevels() {
        guard let currentPack = currentPack else { return }
        guard let currentPackNum = currentPack.packNumber else {
            print("Current Pack not yet set")
            return
        }
        
        // Create a semaphore to make it synchronous
//        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            do {
                let playableLevels = try await fetchPlayableLevelsUseCase.execute(packNum: currentPackNum)
                print("\(#file), \(#function), \(#line)")

                await MainActor.run {
                    print("\(#file), \(#function), \(#line)")
                    self.playableLevels = playableLevels
                    print("Full")
//                    semaphore.signal()
                }
                print("\(#file), \(#function), \(#line)")
            } catch {
                print("\(#file), \(#function), \(#line)")
//                semaphore.signal()
            }
        }
        print("\(#file), \(#function), \(#line)")

//        semaphore.wait() // Wait for the async operation to complete
    }
        
//        Task { @MainActor in
//            do {
//                let playableLevels = try await fetchPlayableLevelsUseCase.execute(packNum: currentPackNum)
//                
//                await MainActor.run {
//                    self.playableLevels = playableLevels  // ✅ Runs on Main Thread
//                    print("Full")
//
//                }
//            }
//            catch {
//                print("Error fetching playable levels: \(error)")
//            }
//        }
//    }
    
    func deleteAllPlayableLevelsInternal() {
        guard let currentPack = currentPack else {
            return
        }

        guard let currentPackNum = currentPack.packNumber else {
            print("Current Pack not yet set")
            return
        }

        Task { @MainActor in
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



