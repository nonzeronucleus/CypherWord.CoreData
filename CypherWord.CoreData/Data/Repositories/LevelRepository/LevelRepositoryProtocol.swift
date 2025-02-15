import Foundation

protocol LevelRepositoryProtocol: FileRepositoryProtocol {
    func fetchLevelByID(id: UUID, completion: @escaping (Result<LevelMO?, Error>) -> Void)

    func addLayout(completion: @escaping (Result<Void, Error>) -> Void)
    func addPlayableLevel(level: Level, completion: @escaping (Result<Void, Error>) -> Void) 

    func deleteAll(levelType: LevelType, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(levelID: UUID, completion: @escaping (Result<Void, Error>) -> Void) 
    func saveLevel(level: Level, completion: @escaping (Result<Void, Error>) -> Void)
}

