protocol LoadManifestUseCaseProtocol {
    func execute() async throws -> Manifest
}

class LoadManifestUseCase: LoadManifestUseCaseProtocol {
    var levelRepository: PlayableLevelRepositoryProtocol
    
    init(levelRepository: PlayableLevelRepositoryProtocol) {
        self.levelRepository = levelRepository
    }
    
    func execute() async throws -> Manifest {
        try await levelRepository.getManifest()
    }
}
