import Foundation

protocol LevelRepositoryProtocol: SaveableRepositoryProtocol {
    func fetchLevelByID(id: UUID, completion: @escaping (Result<LevelMO?, Error>) -> Void)

    func addLayout() async throws

    //    func addLayout(completion: @escaping (Result<Void, Error>) -> Void)
    func addPlayableLevel(level: LevelDefinition, completion: @escaping (Result<Void, Error>) -> Void)

//    func deleteAll(levelType: LevelType, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteAll(levelType: LevelType) async throws

    func delete(levelID: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func saveLevel(level: LevelDefinition, completion: @escaping (Result<Void, Error>) -> Void)
}

