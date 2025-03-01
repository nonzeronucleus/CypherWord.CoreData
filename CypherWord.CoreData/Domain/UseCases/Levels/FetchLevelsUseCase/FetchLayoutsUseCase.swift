import Dependencies

class FetchLayoutsUseCase: LevelsUseCase, FetchLevelsUseCaseProtocol {
    
    func execute() async throws -> [LevelDefinition] {
        return try await levelRepository.fetchLevels(levelType:.layout)
    }

//    func execute(completion: @escaping (Result<[LevelDefinition], Error>) -> Void) {
//        levelRepository.fetchLevels(levelType:.layout, completion: completion)
//    }
}
