protocol LoadManifestUseCaseProtocol {
    func execute() async throws -> Manifest
}

class LoadManifestUseCase: LoadManifestUseCaseProtocol {
    var levelRepository: LevelRepositoryProtocol
    
    init(levelRepository: LevelRepositoryProtocol) {
        self.levelRepository = levelRepository
    }
    
    func execute() async throws -> Manifest {
        try await levelRepository.getManifest()
    }
}
