import Foundation

protocol LevelRepositoryProtocol: SaveableRepositoryProtocol {
    func fetchLevelByID(id: UUID, completion: @escaping (Result<LevelMO?, Error>) -> Void)

    func addLayout() async throws

    func addPlayableLevel(level: LevelDefinition, completion: @escaping (Result<Void, Error>) -> Void)

    func deleteAll(levelType: LevelType) async throws

    func delete(levelID: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func saveLevel(level: LevelDefinition, completion: @escaping (Result<Void, Error>) -> Void)
}

