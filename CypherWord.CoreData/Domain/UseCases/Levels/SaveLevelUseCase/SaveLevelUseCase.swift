import Dependencies

class SaveLevelUseCase : LevelsUseCase, SaveLevelUseCaseProtocol {
    
//    @MainActor
    func execute(level:LevelDefinition) async throws {
        try await levelRepository.prepareLevelMO(from: level)
        levelRepository.commit()
    }
}
