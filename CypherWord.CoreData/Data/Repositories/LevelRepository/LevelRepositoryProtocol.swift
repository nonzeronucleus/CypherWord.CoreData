import Foundation

protocol LevelRepositoryProtocol: SaveableRepositoryProtocol {
    func fetchLevelByID(id: UUID) async throws -> LevelMO?
    func addPlayableLevel(level: LevelDefinition) async throws
    
    func delete(levelID: UUID) async throws
    func saveLevel(level: LevelDefinition) async throws

    func addLayout() async throws

    func deleteAll(levelType: LevelType) async throws
}
