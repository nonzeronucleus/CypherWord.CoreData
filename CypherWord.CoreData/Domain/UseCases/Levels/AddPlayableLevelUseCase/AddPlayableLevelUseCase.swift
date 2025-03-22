import Foundation
import Dependencies

protocol AddPlayableLevelUseCaseProtocol {
    func execute(layout: LevelDefinition) async throws
}


class AddPlayableLevelUseCase : LevelsUseCase, AddPlayableLevelUseCaseProtocol {
    func execute(layout: LevelDefinition) async throws {
        @Dependency(\.uuid) var uuid
        let nextNum = try levelRepository.fetchHighestNumber(levelType: .playable) + 1
        
        let level = LevelDefinition(
            id: uuid(),
            number: nextNum,
            gridText: layout.gridText,
            letterMap: layout.letterMap
        )
        
        try await levelRepository.prepareLevelMO(from: level)
    
        levelRepository.commit()



//        try await levelRepository.addPlayableLevel(level: level)
    }
}



//@MainActor
//func addPlayableLevel(level: LevelDefinition) async throws {
//    var levelMO = LevelMO(context: container.viewContext)
//    
//    levelMO.id = UUID()
//    levelMO.number = try self.fetchHighestNumberInternal(levelType: .playable) + 1
//    LevelMapper.toLevelMO(from: level, to: &levelMO)
//    save()
//}
//



//func execute() async throws -> [LevelDefinition] {
//    @Dependency(\.uuid) var uuid
//    let nextNum = try levelRepository.fetchHighestNumber(levelType: .layout) + 1
//
//    let layout = LevelDefinition(
//        id: uuid(),
//        number: nextNum,
//        attemptedLetters: ""
//    )
//    
//    try await levelRepository.prepareLevelMO(from: layout)
//    
//    levelRepository.commit()
//    
//    return try await levelRepository.fetchLevels(levelType: .layout)
//}
