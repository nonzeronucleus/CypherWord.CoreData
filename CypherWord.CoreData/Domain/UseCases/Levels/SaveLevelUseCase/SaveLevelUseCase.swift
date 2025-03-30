import Dependencies

class SaveLevelUseCase : LevelsUseCase, SaveLevelUseCaseProtocol {
    
    @MainActor
    func execute(level:LevelDefinition) async throws {
        print("1")
        try await levelRepository.prepareLevelMO(from: level)
        print("2")
        levelRepository.commit()
        print("3")
    }
}
