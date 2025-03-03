import Foundation

protocol FileRepositoryProtocol {
    func saveLayouts(levels: [LevelDefinition]) async throws
    
    func fetchLevels(levelType: LevelType) async throws -> [LevelDefinition]
    func saveLevels(levels: [LevelDefinition]) async throws

//    func saveLevels(levels: [LevelDefinition], levenNum:Int?) async throws

//    func listPacks(levelType: LevelType) async throws -> [URL]
}
