protocol ResizeGridUseCaseProtocol {
    func execute(inputGrid: Crossword, newSize:Int) async throws -> Crossword
}
