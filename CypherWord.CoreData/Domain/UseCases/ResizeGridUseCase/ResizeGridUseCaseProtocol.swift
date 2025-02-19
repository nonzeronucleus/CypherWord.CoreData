protocol ResizeGridUseCaseProtocol {
    func execute(inputGrid: Crossword, newSize:Int, completion: @escaping (Result<Crossword, any Error>) -> Void)
}
