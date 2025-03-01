class FetchLevelsUseCaseMock: FetchLevelsUseCaseProtocol {
    var levels : [LevelDefinition] = []
    init(levels:[LevelDefinition]) {
        self.levels = levels
    }
    
    func execute() async throws ->[LevelDefinition]{
        return levels
    }
}
