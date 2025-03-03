import Foundation

protocol LevelRepositoryProtocol {
    func fetchLevels(levelType: LevelType) async throws -> [LevelDefinition]
    func saveLevels(levels: [LevelDefinition]) async throws
    
    func fetchLevelByID(id: UUID) async throws -> LevelMO?
    func addPlayableLevel(level: LevelDefinition) async throws
    
    func delete(levelID: UUID) async throws
    func saveLevel(level: LevelDefinition) async throws

    func addLayout() async throws

    func deleteAll(levelType: LevelType) async throws
}
