protocol CrosswordPopulatorUseCaseProtocol {
    func execute(initCrossword:Crossword, completion: @escaping (Result<(Crossword, CharacterIntMap), Error>) -> Void)
    func executeAsync(initCrossword: Crossword) async -> Result<(Crossword, CharacterIntMap), Error> 

}
