protocol CrosswordPopulatorUseCaseProtocol {
    func executeAsync(initCrossword: Crossword) async throws -> (Crossword, CharacterIntMap)
}
