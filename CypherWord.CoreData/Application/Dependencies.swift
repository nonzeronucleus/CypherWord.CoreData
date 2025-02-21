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


// Mark - Settings Repository

extension DependencyValues {
    var settingsRepository: SettingsRepositoryProtocol {
        get { self[SettingsRepositoryKey.self] }
        set { self[SettingsRepositoryKey.self] = newValue }
    }
}

private enum SettingsRepositoryKey: DependencyKey {
    static let liveValue: SettingsRepositoryProtocol = SettingsRepository()
}
