protocol ResizeGridUseCaseProtocol {
    func executeAsync(inputGrid: Crossword, newSize:Int) async -> Result<Crossword, any Error>
    func execute(inputGrid: Crossword, newSize:Int, completion: @escaping (Result<Crossword, any Error>) -> Void)
}
