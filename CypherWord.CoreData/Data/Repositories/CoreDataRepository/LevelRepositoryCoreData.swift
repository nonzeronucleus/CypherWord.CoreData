import CoreData
import Dependencies
import Foundation

protocol LevelRepositoryProtocol {

    func prepareLevelMO(from level:LevelDefinition) async throws
    func commit()

    func levelExists(level:LevelDefinition) async throws -> Bool

    func fetchLevelByID(id: UUID) async throws -> LevelMO?
    func delete(levelID: UUID) async throws

    func deleteAllLevels(levelType: LevelType) throws

    func fetchHighestLevelNumber(levelType: LevelType) throws -> Int
}

protocol PlayableLevelRepositoryProtocol: LevelRepositoryProtocol {
    func writePackToManifest(playableFileDefinition: PlayableLevelFileDefinition) async throws
    func fetchPlayableLevels(packNum: Int) async throws -> [LevelDefinition]
    func getManifest() async throws -> Manifest
    func deleteAllPacks() throws
    func getCurrentPackNum() -> Int
}

protocol LayoutRepositoryProtocol: LevelRepositoryProtocol {
    func fetchLayouts() async throws -> [LevelDefinition]
}

extension LevelStorageCoreData:LevelRepositoryProtocol {
    func levelExists(level: LevelDefinition) async throws -> Bool {
        return try findLevel(id: level.id) != nil
    }
    
    func commit() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    
    func fetchHighestLevelNumber(levelType: LevelType) throws -> Int{
        return try Int(fetchHighestNumberInternal(levelType: levelType))
    }
    
    
    func prepareLevelMO(from level:LevelDefinition) async throws {
        try await MainActor.run {
            var levelMO = try findLevel(id: level.id)
            
            if levelMO == nil {
                levelMO = LevelMO(context: container.viewContext)
            }
            
            guard let number = level.number else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Level number must be set"])
            }
            
            if let levelMO {
                levelMO.id = level.id
                levelMO.number = Int64(number)
                levelMO.gridText = level.gridText
                levelMO.letterMap = level.letterMap
                levelMO.attemptedLetters = level.attemptedLetters
                levelMO.packId = level.packId
                levelMO.numCorrectLetters = Int16(level.numCorrectLetters)
            }
        }
    }
    
    @MainActor
    func delete(levelID: UUID) async throws {
        let request: NSFetchRequest<NSFetchRequestResult> = createFetchLevelRequest(resultType: NSFetchRequestResult.self, levelID: levelID)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        try container.viewContext.execute(deleteRequest)
        try container.viewContext.save()
    }
    
    func deleteAllLevels(levelType: LevelType) throws {
        let request: NSFetchRequest<NSFetchRequestResult> = createFetchLevelsRequest(resultType: NSFetchRequestResult.self, levelType: levelType)

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        try container.viewContext.execute(deleteRequest)
    }
}


extension LevelStorageCoreData: LayoutRepositoryProtocol {
    @MainActor
    func fetchLayouts() async throws -> [LevelDefinition] {
        do {
            let fetchRequest: NSFetchRequest<LevelMO> = createFetchLevelsRequest(resultType: LevelMO.self, levelType: .layout)
            let savedEntities = try container.viewContext.fetch(fetchRequest)
            
            let levels = savedEntities.map( {
                entity in LevelMapper.toLevelDefinition(mo: entity)
            })
            return levels
        }
    }
}


extension LevelStorageCoreData: PlayableLevelRepositoryProtocol {
    @MainActor
    func writePackToManifest(playableFileDefinition: PlayableLevelFileDefinition) async throws {
        try await MainActor.run {
            if let packNumber = playableFileDefinition.packNumber {
                var packMO:PackMO?

                packMO = try fetchPackByNumber(number: packNumber)

                if packMO == nil {
                    packMO = PackMO(context:  container.viewContext)
                }

                if let packMO {
                    packMO.number = Int16(packNumber)
                    packMO.id = playableFileDefinition.id
                }
            }

            else {
                fatalError(#function + ": Pack number must be an Int")
            }
        }
    }
    
    @MainActor
    func fetchPlayableLevels(packNum:Int) async throws -> [LevelDefinition] {
        do {
            currentPackNum = packNum
            let manifest = try await getManifest()
            
            guard let packDefinition = manifest.getLevelFileDefinition(forNumber: packNum) else {
                throw NSError(domain: "LevelStorageCoreData", code: 1, userInfo: [NSLocalizedDescriptionKey : "Couldn't find pack \(packNum)"])
            }
            
            let fetchRequest: NSFetchRequest<LevelMO> = createFetchLevelsRequest(resultType: LevelMO.self, levelType: .playable, packId: packDefinition.id)
            let savedEntities = try container.viewContext.fetch(fetchRequest)
            
            let levels = savedEntities.map( {
                entity in LevelMapper.toLevelDefinition(mo: entity)
            })
            return levels
        }
    }
    
    func getCurrentPackNum() -> Int {
        return currentPackNum
    }
    
    @MainActor
    func getManifest() async throws -> Manifest {
        let packs = try fetchPacks()
        
        return Manifest(levels: PackMapper.toFileDefinitions(mos: packs))
    }
    
    func fetchLevelByID(id: UUID) async throws -> LevelMO? {
        return try findLevel(id: id)
    }
    
    func deleteAllPacks() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = createFetchPacksRequest(resultType: NSFetchRequestResult.self)

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        try container.viewContext.execute(deleteRequest)
    }
}


class LevelStorageCoreData {
    private let levelEntityName: String = "LevelMO"
    private let packEntityName: String = "PackMO"
    private var currentPackNum: Int = 1

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LevelsContainer")

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()


    private var dbLocation: URL? {
        return container.persistentStoreCoordinator.persistentStores.first?.url
    }


    private func createFetchLevelsRequest<T>(resultType: T.Type, levelType: LevelType, packId: UUID? = nil) -> NSFetchRequest<T> where T: NSFetchRequestResult {
        let request = NSFetchRequest<T>(entityName: levelEntityName)
        if levelType == .playable {
            request.predicate = NSPredicate(format: "letterMap != nil")
        } else {
            request.predicate = NSPredicate(format: "letterMap == nil")
        }
        if let packId {
            request.predicate = NSPredicate(format: "packId == %@", packId as CVarArg)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
        return request
    }


    private func createFetchLevelRequest<T>(resultType: T.Type, levelID: UUID) -> NSFetchRequest<T> where T: NSFetchRequestResult {
        let request = NSFetchRequest<T>(entityName: levelEntityName)
        request.predicate = NSPredicate(format: "id == %@", levelID as CVarArg)

        return request
    }


    private func createFetchPacksRequest<T>(resultType: T.Type) -> NSFetchRequest<T> where T: NSFetchRequestResult {
        let request = NSFetchRequest<T>(entityName: packEntityName)
//        request.predicate = NSPredicate(format: "id == %@", levelID as CVarArg)

        return request
    }


    private func fetchHighestNumberInternal(levelType: LevelType) throws -> Int64 {
        // Create a fetch request for dictionaries (so we get a dictionary result, not full managed objects)
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "LevelMO")
        fetchRequest.resultType = .dictionaryResultType

        // Create an expression for the key path "number"
        let keyPathExpression = NSExpression(forKeyPath: "number")

        // Add a predicate to filter for objects where letterMap is nil.
        if levelType == .playable {
            fetchRequest.predicate = NSPredicate(format: "letterMap != nil")
        } else {
            fetchRequest.predicate = NSPredicate(format: "letterMap == nil")
        }
        // Create an expression that calculates the maximum value for the key path
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keyPathExpression])

        // Create an expression description that holds the result of the max() function
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "maxNumber"
        expressionDescription.expression = maxExpression
        expressionDescription.expressionResultType = .integer64AttributeType

        // Set the properties to fetch (only the computed maximum value)
        fetchRequest.propertiesToFetch = [expressionDescription]

        do {
            // Execute the fetch request
            if let resultDict = try container.viewContext.fetch(fetchRequest).first,
               let maxNumber = resultDict["maxNumber"] as? Int64 {
                return maxNumber
            }
        }

        return 0
    }






    private func findLevel(id:UUID) throws -> LevelMO? {
        let request: NSFetchRequest<LevelMO> = createFetchLevelRequest(resultType: LevelMO.self, levelID: id)
        let level = try container.viewContext.fetch(request).first

        return level
    }


    private func fetchPacks() throws -> [PackMO] {
        let request: NSFetchRequest<PackMO> = createFetchPacksRequest(resultType: PackMO.self)
        let packs = try container.viewContext.fetch(request)

        return packs
    }

    @MainActor
    private func fetchPackByNumber(number:Int) throws -> PackMO? {
        let request: NSFetchRequest<PackMO> = createFetchPacksRequest(resultType: PackMO.self)

        request.predicate = NSPredicate(format: "number == %@", number as NSNumber)

        let pack = try container.viewContext.fetch(request).first

        return pack
    }
}


