protocol CrosswordPopulatorUseCaseProtocol {
    func execute(initCrossword:Crossword, completion: @escaping (Result<(Crossword, CharacterIntMap), Error>) -> Void)
}
