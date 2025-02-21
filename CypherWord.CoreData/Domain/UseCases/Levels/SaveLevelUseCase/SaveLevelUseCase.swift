import Dependencies

class SaveLevelUseCase : LevelsUseCase, SaveLevelUseCaseProtocol {
    
     func execute(level: LevelDefinition, completion: @escaping (Result<Void, any Error>) -> Void) {
         levelRepository.saveLevel(level: level, completion: completion)
    }
}
