import Foundation

protocol LevelRepositoryProtocol: FileRepositoryProtocol {
//    func fetchLevels(levelType: Level.LevelType, completion: @escaping (Result<[Level], Error>) -> Void)
    func fetchLevelByID(id: UUID, completion: @escaping (Result<LevelMO?, Error>) -> Void)

    func addLayout(completion: @escaping (Result<Void, Error>) -> Void)
    func addPlayableLevel(level: Level, completion: @escaping (Result<Void, Error>) -> Void) 

    func deleteAll(levelType: Level.LevelType, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(levelID: UUID, completion: @escaping (Result<Void, Error>) -> Void) 
    func saveLevel(level: Level, completion: @escaping (Result<Void, Error>) -> Void)
}

