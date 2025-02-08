import CoreData

extension LevelStorageCoreData:LevelRepositoryProtocol {
    
    func fetchLevels(levelType: Level.LevelType, completion: @escaping (Result<[Level], Error>) -> Void) {
        do {
            let fetchRequest: NSFetchRequest<LevelMO> = createFetchRequest(resultType: LevelMO.self, levelType: levelType)
            let savedEntities = try container.viewContext.fetch(fetchRequest)
            
            let levels = savedEntities.map( {
                entity in Level(id: entity.id ?? UUID(), number: Int(entity.number), gridText: entity.gridText, letterMap: entity.letterMap)
            })
            completion(.success(levels))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    
    func addLayout(completion: @escaping (Result<Void, Error>) -> Void) {
        let levelMO = LevelMO(context: container.viewContext)

        do {
            levelMO.id = UUID()
            levelMO.number = try self.fetchHighestNumber() + 1
            levelMO.gridText = nil
            levelMO.letterMap = nil
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
        
        save()
    }

    func save(completion: @escaping (Result<Void, any Error>) -> Void) {
        do {
            try container.viewContext.save()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func deleteAll(levelType: Level.LevelType, completion: @escaping (Result<Void, any Error>) -> Void) {
        do {
            try deleteAll(levelType: levelType)
            try container.viewContext.save()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
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

    private let entityName: String = "LevelMO"
    
    private func createFetchRequest<T>(resultType: T.Type, levelType: Level.LevelType) -> NSFetchRequest<T> where T: NSFetchRequestResult {
        let request = NSFetchRequest<T>(entityName: entityName)
        if levelType == .playable {
            request.predicate = NSPredicate(format: "letterMap != nil")
        } else {
            request.predicate = NSPredicate(format: "letterMap == nil")
        }
        request.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
        return request
    }
    
    
    private func fetchHighestNumber() throws -> Int64 {
        // Create a fetch request for dictionaries (so we get a dictionary result, not full managed objects)
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "LevelMO")
        fetchRequest.resultType = .dictionaryResultType

        // Create an expression for the key path "number"
        let keyPathExpression = NSExpression(forKeyPath: "number")
        
        // Add a predicate to filter for objects where letterMap is nil.
        fetchRequest.predicate = NSPredicate(format: "letterMap == nil")
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
    
    
    func deleteAll(levelType: Level.LevelType) throws {
        let request: NSFetchRequest<NSFetchRequestResult> = createFetchRequest(resultType: NSFetchRequestResult.self, levelType: levelType)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
        }
    }

    
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
}

