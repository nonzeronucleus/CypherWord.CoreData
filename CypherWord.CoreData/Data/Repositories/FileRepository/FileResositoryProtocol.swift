import Foundation

protocol FileRepositoryProtocol: SaveableRepositoryProtocol {
    func listPacks(levelType: LevelType, completion: @escaping (Result<[URL], any Error>) -> Void)
}
