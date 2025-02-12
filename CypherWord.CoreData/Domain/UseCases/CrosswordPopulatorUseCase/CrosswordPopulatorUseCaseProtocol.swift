protocol CrosswordPopulatorUseCaseProtocol {
    func executeAsync(initCrossword: Crossword) async -> Result<(Crossword, CharacterIntMap), Error>
}
