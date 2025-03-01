import Dependencies
class FetchPlayableLevelsUseCase: LevelsUseCase, FetchLevelsUseCaseProtocol {
    func execute() async throws -> [LevelDefinition] {
        return try await levelRepository.fetchLevels(levelType:.playable)
    }

    
    //    func execute(completion: @escaping (Result<[LevelDefinition], Error>) -> Void) {
//        levelRepository.fetchLevels(levelType:.playable, completion: completion)
//    }
}
