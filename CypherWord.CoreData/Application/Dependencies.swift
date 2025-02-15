import Dependencies

// Mark - LevelRepositoryProtocol

extension DependencyValues {
    var levelRepository: LevelRepositoryProtocol {
        get { self[LevelRepositoryKey.self] }
        set { self[LevelRepositoryKey.self] = newValue }
    }
}

private enum LevelRepositoryKey: DependencyKey {
    static let liveValue: LevelRepositoryProtocol =  LevelStorageCoreData()
    static let previewValue: LevelRepositoryProtocol =  FakeLevelRepository()
}


// Mark - FileRepositoryProtocol

extension DependencyValues {
    var fileRepository: FileRepositoryProtocol {
        get { self[FileRepositoryKey.self] }
        set { self[FileRepositoryKey.self] = newValue }
    }
}

private enum FileRepositoryKey: DependencyKey {
    static let liveValue: FileRepositoryProtocol =  FileRepository()
    static let previewValue: FileRepositoryProtocol =  FileRepository()
}



// Mark - FetchLevelsUseCaseProtocol

extension DependencyValues {
    var fetchPlayableLevelsUseCase: FetchLevelsUseCaseProtocol {
        get { self[FetchPlayableLevelsUseCaseKey.self] }
        set { self[FetchPlayableLevelsUseCaseKey.self] = newValue }
    }
}

private enum FetchPlayableLevelsUseCaseKey: DependencyKey {
    static let liveValue: FetchLevelsUseCaseProtocol = FetchPlayableLevelsUseCase()
}


// Mark - FetchLevelsUseCaseProtocol

extension DependencyValues {
    var fetchLayoutsUseCase: FetchLevelsUseCaseProtocol {
        get { self[FetchLayoutsUseCaseKey.self] }
        set { self[FetchLayoutsUseCaseKey.self] = newValue }
    }
}

private enum FetchLayoutsUseCaseKey: DependencyKey {
    static let liveValue: FetchLevelsUseCaseProtocol = FetchLayoutsUseCase()
}

// Mark - AddLayoutUseCaseProtocol

extension DependencyValues {
    var addLayoutUseCase: AddLayoutUseCaseProtocol {
        get { self[AddLayoutUseCaseKey.self] }
        set { self[AddLayoutUseCaseKey.self] = newValue }
    }
}

private enum AddLayoutUseCaseKey: DependencyKey {
    static let liveValue: AddLayoutUseCaseProtocol = AddLayoutUseCase()
}



// Mark - DeleteAllLevelsUseCaseProtocol

extension DependencyValues {
    var deleteAllLevelsUseCase: DeleteAllLevelsUseCaseProtocol {
        get { self[DeleteAllLevelsUseCaseKey.self] }
        set { self[DeleteAllLevelsUseCaseKey.self] = newValue }
    }
}

private enum DeleteAllLevelsUseCaseKey: DependencyKey {
    static let liveValue: DeleteAllLevelsUseCaseProtocol = DeleteAllLevelsUseCase()
}

// Mark - SaveLevelUseCase

extension DependencyValues {
    var saveLevelUseCase: SaveLevelUseCaseProtocol {
        get { self[SaveLevelUseCaseKey.self] }
        set { self[SaveLevelUseCaseKey.self] = newValue }
    }
}

private enum SaveLevelUseCaseKey: DependencyKey {
    static let liveValue: SaveLevelUseCaseProtocol = SaveLevelUseCase()
}

// Mark - Import Use case

extension DependencyValues {
    var importLevelsUseCase: ImportLevelsUseCaseProtocol {
        get { self[ImportLevelsUseCaseKey.self] }
        set { self[ImportLevelsUseCaseKey.self] = newValue }
    }
}

private enum ImportLevelsUseCaseKey: DependencyKey {
    static let liveValue: ImportLevelsUseCaseProtocol = ImportLevelsUseCase()
}

// Mark - Save New Playable Level

extension DependencyValues {
    var addPlayableLevelUseCase: AddPlayableLevelUseCaseProtocol {
        get { self[AddPlayableLevelUseCaseKey.self] }
        set { self[AddPlayableLevelUseCaseKey.self] = newValue }
    }
}

private enum AddPlayableLevelUseCaseKey: DependencyKey {
    static let liveValue: AddPlayableLevelUseCaseProtocol = AddPlayableLevelUseCase()
}

// Mark - Save New Playable Level

extension DependencyValues {
    var fetchLevelByIDUseCase: FetchLevelByIDUseCaseProtocol {
        get { self[FetchLevelByIDUseCaseKey.self] }
        set { self[FetchLevelByIDUseCaseKey.self] = newValue }
    }
}

private enum FetchLevelByIDUseCaseKey: DependencyKey {
    static let liveValue: FetchLevelByIDUseCaseProtocol = FetchLevelByIDUseCase()
}


// Mark - Delete Level

extension DependencyValues {
    var deleteLevelUseCase: DeleteLevelUseCaseProtocol {
        get { self[DeleteLevelUseCaseKey.self] }
        set { self[DeleteLevelUseCaseKey.self] = newValue }
    }
}

private enum DeleteLevelUseCaseKey: DependencyKey {
    static let liveValue: DeleteLevelUseCaseProtocol = DeleteLevelUseCase()
}

// Mark - Export

extension DependencyValues {
    var exportAllUseCase: ExportAllUseCaseProtocol {
        get { self[ExportAllUseCaseKey.self] }
        set { self[ExportAllUseCaseKey.self] = newValue }
    }
}

private enum ExportAllUseCaseKey: DependencyKey {
    static let liveValue: ExportAllUseCaseProtocol = ExportAllUseCase()
}


