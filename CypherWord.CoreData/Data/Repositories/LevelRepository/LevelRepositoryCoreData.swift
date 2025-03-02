import CoreData

extension LevelStorageCoreData:LevelRepositoryProtocol {
    func fetchLevelByID(id: UUID) async throws -> LevelMO? {
        return try findLevel(id: id)
    }
    
    func addPlayableLevel(level: LevelDefinition) async throws {
        var levelMO = LevelMO(context: container.viewContext)
        
        levelMO.id = UUID()
        levelMO.number = try self.fetchHighestNumber(levelType: .playable) + 1
        LevelMapper.map(from: level, to: &levelMO)
        save()
    }
    
    func delete(levelID: UUID) async throws {
        let request: NSFetchRequest<NSFetchRequestResult> = createFetchLevelRequest(resultType: NSFetchRequestResult.self, levelID: levelID)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        try container.viewContext.execute(deleteRequest)
        try container.viewContext.save()
    }
    
    func saveLevel(level: LevelDefinition) async throws {
        var levelMO = try findLevel(id: level.id)
        
        if levelMO == nil {
            levelMO = LevelMO(context: container.viewContext)
            levelMO?.id = UUID()
            levelMO?.number = try self.fetchHighestNumber(levelType: level.levelType) + 1
            
            //                levelMO.id = level.id
        }
        
        if var levelMO = levelMO {
            LevelMapper.map(from: level, to: &levelMO)
            save()
        }
        else {
            throw OptionalUnwrappingError.foundNil("Couldn't create LevelMO")
        }
    }
    
    func addLayout() async throws {
        let levelMO = LevelMO(context: container.viewContext)
        
        do {
            levelMO.id = UUID()
            levelMO.number = try self.fetchHighestNumber(levelType: .layout) + 1
            levelMO.gridText = nil
            levelMO.letterMap = nil
            save()
        }
    }
    
    func fetchLevels(levelType: LevelType) async throws -> [LevelDefinition] {
        do {
            let fetchRequest: NSFetchRequest<LevelMO> = createFetchLevelsRequest(resultType: LevelMO.self, levelType: levelType)
            let savedEntities = try container.viewContext.fetch(fetchRequest)
            
            let levels = savedEntities.map( {
                entity in LevelMapper.map(mo: entity)
            })
            return levels
        }
    }
    
    func saveLevels(levels: [LevelDefinition]) async throws {
        do {
            for level in levels {
                if try findLevel(id: level.id) == nil {
                    let _ = try LevelMapper.map(context: container.viewContext, levelDefinition: level) {
                        return try fetchHighestNumber(levelType: level.levelType) + 1
                    }

                    save()
                }
            }
        }
    }
}

class LevelStorageCoreData {
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
    

    var dbLocation: URL? {
        return container.persistentStoreCoordinator.persistentStores.first?.url
    }

    
    private let entityName: String = "LevelMO"
    
    private func createFetchLevelsRequest<T>(resultType: T.Type, levelType: LevelType) -> NSFetchRequest<T> where T: NSFetchRequestResult {
        let request = NSFetchRequest<T>(entityName: entityName)
        if levelType == .playable {
            request.predicate = NSPredicate(format: "letterMap != nil")
        } else {
            request.predicate = NSPredicate(format: "letterMap == nil")
        }
        request.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
        return request
    }
    

    private func createFetchLevelRequest<T>(resultType: T.Type, levelID: UUID) -> NSFetchRequest<T> where T: NSFetchRequestResult {
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %@", levelID as CVarArg)
        
        return request
    }

    
    private func fetchHighestNumber(levelType: LevelType) throws -> Int64 {
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
    
    
    func deleteAll(levelType: LevelType) throws {
        let request: NSFetchRequest<NSFetchRequestResult> = createFetchLevelsRequest(resultType: NSFetchRequestResult.self, levelType: levelType)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
        }
    }
    
    
    
    func findLevel(id:UUID) throws -> LevelMO? {
        let request: NSFetchRequest<LevelMO> = createFetchLevelRequest(resultType: LevelMO.self, levelID: id)
        let level = try container.viewContext.fetch(request).first
        
        return level
    }

    
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
}
    

