import Dependencies

class FetchLayoutsUseCase: LevelsUseCase, FetchLevelsUseCaseProtocol {
    
    func execute() async throws -> [LevelDefinition] {
        return try await levelRepository.fetchLayouts()
    }
}
