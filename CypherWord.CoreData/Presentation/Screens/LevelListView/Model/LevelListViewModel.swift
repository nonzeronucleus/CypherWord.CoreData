import Foundation
import SwiftUI
import Dependencies
import Combine


class LevelListViewModel: ObservableObject {
    var settingsViewModel: SettingsViewModel

    private var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol
    private var fetchPlayableLevelsUseCase: FetchLevelsUseCaseProtocol
    private var deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol
    private var addLayoutUseCase: AddLayoutUseCaseProtocol
    private var exportAllUseCase: ExportAllUseCaseProtocol

    @Published var allLevels: [LevelDefinition] = []
    @Published var displayableLevels: [LevelDefinition] = []
    @Published var error:String?
    @Published private(set) var selectedLevel: LevelDefinition?
    @Published var levelType: LevelType
    @Published var isBusy: Bool = false
    
    @Published var showCompleted: Bool = false

    private var navigationViewModel: NavigationViewModel?
    private var cancellables = Set<AnyCancellable>()

    init(levelType: LevelType,
         navigationViewModel:NavigationViewModel,
         settingsViewModel: SettingsViewModel,
         fetchLayoutsUseCase: FetchLevelsUseCaseProtocol = FetchLayoutsUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue),
         fetchPlayableLevelsUseCase: FetchLevelsUseCaseProtocol = FetchPlayableLevelsUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue),
         deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol = DeleteAllLevelsUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue),
         addLayoutUseCase: AddLayoutUseCaseProtocol = AddLayoutUseCase(levelRepository: Dependency(\.levelRepository).wrappedValue),
         exportAllUseCase: ExportAllUseCaseProtocol = ExportAllUseCase(fileRepository: Dependency(\.fileRepository).wrappedValue)
    ){
        self.levelType = levelType
        self.navigationViewModel = navigationViewModel
        self.settingsViewModel = settingsViewModel
        self.fetchLayoutsUseCase = fetchLayoutsUseCase
        self.fetchPlayableLevelsUseCase = fetchPlayableLevelsUseCase
        self.deleteAllLevelsUseCase = deleteAllLevelsUseCase
        self.addLayoutUseCase = addLayoutUseCase
        self.exportAllUseCase = exportAllUseCase

        showCompleted = settingsViewModel.settings.showCompletedLevels
        
        $allLevels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLevels in
                if let showCompleted = self?.showCompleted {
                    self?.updateDisplayableLevels(levels: newLevels, showCompleted: showCompleted)
                }
            }
            .store(in: &cancellables)
        
        $showCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newShowCompleted in
                if let levels = self?.allLevels {
                    self?.updateDisplayableLevels(levels: levels, showCompleted: newShowCompleted)
                }
            }
            .store(in: &cancellables)
        
        reload()
    }
    
    
    @MainActor
    func addLayout() {
        Task {
            allLevels = try await addLayoutUseCase.execute()
        }
//        addLayoutUseCase.execute { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                    case .success(let levels):
//                        self?.allLevels = levels
//                    case .failure(let error):
//                        self?.error = error.localizedDescription
//                }
//            }
//        }
    }

    
    func deleteAll() {
        Task {
            do {
                let levels = try await deleteAllLevelsUseCase.execute(levelType: levelType)
                await MainActor.run {
                    self.allLevels = levels  // ✅ Ensures update happens on the main thread
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription  // ✅ Ensures error updates on main thread
                }
            }
        }
    }
    
//    func deleteAll() {
//        Task {
//            allLevels = try await deleteAllLevelsUseCase.execute(levelType: levelType)
//        }
//    }
//        deleteAllLevelsUseCase.execute(levelType: levelType, completion: { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                    case .success(let levels):
//                        self?.allLevels = levels
//                    case .failure(let error):
//                        self?.error = error.localizedDescription
//                }
//            }
//        })
//    }
    
    func onSelectLevel(level:LevelDefinition) {
        navigationViewModel?.navigateTo(level:level)
    }
    
    func exportAll() {
        isBusy = true
        
        Task {
            do {
                try await exportAllUseCase.execute(levels: allLevels)
                await MainActor.run {
                    
                    isBusy = false
                }
            } catch {
                await MainActor.run {
                    
                    self.error = error.localizedDescription
                    isBusy = false
                }
            }
        }
        
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            
//            exportAllUseCase.execute(levels: allLevels, completion:  { [weak self] result in
//                DispatchQueue.main.async {
//                    switch result {
//                        case .success():
//                            self?.isBusy = false
//                        case .failure(let error):
//                            self?.error = error.localizedDescription
//                            self?.isBusy = false
//                    }
//                }
//            })
//        }
    }
    
    func navigateToSettings() {
        navigationViewModel?.navigateToSettings()
    }
    
    
    private func reload() {
        switch levelType {
            case .layout:
                fetchLayouts()
            case .playable:
                fetchLevels()
        }
    }
    
    private func updateDisplayableLevels(levels: [LevelDefinition], showCompleted: Bool) {
        objectWillChange.send()
        
        displayableLevels = levels.filter {
            switch levelType {
                case .layout:
                    return true
                case .playable:
                    if (self.showCompleted) {
                        return true
                    }
                    return $0.percentComplete < 1
            }
        }
    }
    
    
    private func fetchLevels() {
        Task {
            do {
                let levels = try await self.fetchPlayableLevelsUseCase.execute()
                await MainActor.run {
                    self.allLevels = levels  // ✅ Runs on main thread
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription  // ✅ Also ensure error updates on main thread
                }
            }
        }
    }

//    private func fetchLevels() {
//        Task {
//            do {
//                self.allLevels = try await self.fetchPlayableLevelsUseCase.execute()
//            } catch {
//                self.error = error.localizedDescription
//            }
//        }
//    }
//        fetchPlayableLevelsUseCase.execute { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let levels):
//                    self?.allLevels = levels
//                case .failure(let error):
//                    self?.error = error.localizedDescription
//                }
//            }
//        }
//    }


    private func fetchLayouts() {
        Task {
            do {
                let levels = try await self.fetchLayoutsUseCase.execute()
                await MainActor.run {
                    self.allLevels = levels  // ✅ Runs on main thread
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription  // ✅ Also ensure error updates on main thread
                }
            }
        }
    }
    
//    private func fetchLayouts() {
//        DispatchQueue.global(qos: .background).async { [self] in
//            Task {
//                do {
//                    self.allLevels = try await self.fetchLayoutsUseCase.execute()
//                }
//                catch {
//                    self.error = error.localizedDescription
//                }
//            }
//        }
////        fetchLayoutsUseCase.execute { [weak self] result in
////            DispatchQueue.main.async {
////                switch result {
////                case .success(let levels):
////                    self?.allLevels = levels
////                case .failure(let error):
////                    self?.error = error.localizedDescription
////                }
////            }
////        }
//    }
}
