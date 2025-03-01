import Foundation

protocol FileRepositoryProtocol: SaveableRepositoryProtocol {
    func listPacks(levelType: LevelType, completion: @escaping (Result<[URL], any Error>) -> Void)
//    func loadPackManifest(completion: @escaping (Result<[PackDefinition], any Error>) -> Void)
//    func savePackManifest(packs: [PackDefinition], completion: @escaping (Result<Void, any Error>) -> Void)
}
