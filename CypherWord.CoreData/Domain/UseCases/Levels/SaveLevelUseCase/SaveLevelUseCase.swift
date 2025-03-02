import Dependencies

class SaveLevelUseCase : LevelsUseCase, SaveLevelUseCaseProtocol {
    
    func execute(level:LevelDefinition) async throws {
         try await levelRepository.saveLevel(level: level)
    }
}
