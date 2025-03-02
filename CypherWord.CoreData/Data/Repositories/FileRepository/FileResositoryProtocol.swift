import Foundation

protocol FileRepositoryProtocol: SaveableRepositoryProtocol {
    func listPacks(levelType: LevelType) async throws -> [URL] 
}
