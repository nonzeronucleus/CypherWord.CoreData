import Foundation
import Dependencies

class AddLayoutUseCase: LevelsUseCase, AddLayoutUseCaseProtocol {
    func execute() async throws -> [LevelDefinition] {
        @Dependency(\.uuid) var uuid
        let nextNum = try levelRepository.fetchHighestNumber(levelType: .layout) + 1

        let layout = LevelDefinition(
            id: uuid(),
            number: nextNum,
            attemptedLetters: ""
        )
        
        try await levelRepository.prepareLevelMO(from: layout)
        
        levelRepository.commit()
        
        
//        try await levelRepository.addLayout()
        
        
        
        return try await levelRepository.fetchLevels(levelType: .layout)
    }
}


//func addLayout() async throws {
//    let levelMO = LevelMO(context: container.viewContext)
//    
//    do {
//        levelMO.id = UUID()
//        levelMO.number = try self.fetchHighestNumber(levelType: .layout) + 1
//        levelMO.gridText = nil
//        levelMO.letterMap = nil
//        save()
//    }
//}

