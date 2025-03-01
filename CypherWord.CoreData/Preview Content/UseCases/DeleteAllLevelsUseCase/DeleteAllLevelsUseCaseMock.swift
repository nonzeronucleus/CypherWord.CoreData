class DeleteAllLevelsUseCaseMock: DeleteAllLevelsUseCaseProtocol {
    func execute(levelType: LevelType) -> [LevelDefinition] {
        return []
    }
//    func execute(levelType: LevelType, completion: @escaping (Result<[LevelDefinition], any Error>) -> Void) {
//        
//    }
}
