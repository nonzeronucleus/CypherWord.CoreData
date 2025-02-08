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
    static let previewValue: LevelRepositoryProtocol =  LevelStorageCoreData()
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






//
//
//let deleteAllLevelsUseCase = DeleteAllLevelsUseCase(repository: layoutRepository, fetchLayoutsUseCase: fetchLayoutsUseCase)
//
//
