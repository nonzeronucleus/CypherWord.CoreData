import Dependencies

class FetchLayoutsUseCase: FetchLevelsUseCaseProtocol {
    var levelRepository: LayoutRepositoryProtocol
    
    init(levelRepository: LayoutRepositoryProtocol) {
        self.levelRepository = levelRepository
    }


    func execute() async throws -> [LevelDefinition] {
        return try await levelRepository.fetchLayouts()
    }
}
