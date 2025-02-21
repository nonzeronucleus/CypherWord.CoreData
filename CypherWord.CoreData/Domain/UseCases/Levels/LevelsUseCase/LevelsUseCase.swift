class LevelsUseCase {
    var levelRepository: LevelRepositoryProtocol
    
    init(levelRepository: LevelRepositoryProtocol) {
        self.levelRepository = levelRepository
    }
}
