import CoreData

extension LevelStorageCoreData:LevelRepositoryProtocol {
    func saveLevels(_ levels: [Level], completion: @escaping (Result<Void, any Error>) -> Void) {
        do {
            for level in levels {
                if try findLevel(id: level.id) == nil {
                    let levelMO = LevelMO(context: container.viewContext)
                    levelMO.id = level.id
                    levelMO.number = try fetchHighestNumber(levelType: level.levelType) + 1 //Int64(level.number)
                    levelMO.gridText = level.gridText
                    levelMO.letterMap = level.letterMap
                    save()
                }
            }
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
        
    }
    
    func fetchLevels(levelType: Level.LevelType, completion: @escaping (Result<[Level], Error>) -> Void) {
        do {
            let fetchRequest: NSFetchRequest<LevelMO> = createFetchLevelsRequest(resultType: LevelMO.self, levelType: levelType)
            let savedEntities = try container.viewContext.fetch(fetchRequest)
            
            let levels = savedEntities.map( {
                entity in Level(id: entity.id ?? UUID(), number: Int(entity.number), gridText: entity.gridText, letterMap: entity.letterMap)
            })
            completion(.success(levels))
        } catch let error {
            completion(.failure(error))
        }
    }

    func fetchLevelByID(id: UUID, completion: @escaping (Result<LevelMO?, Error>) -> Void) {
        do {
            let levelMO = try findLevel(id: id)
            completion(.success(levelMO))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func addLayout(completion: @escaping (Result<Void, Error>) -> Void) {
        let levelMO = LevelMO(context: container.viewContext)

        do {
            levelMO.id = UUID()
            levelMO.number = try self.fetchHighestNumber(levelType: .layout) + 1
            levelMO.gridText = nil
            levelMO.letterMap = nil
            save()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
        
    }
    
    func addPlayableLevel(level: Level, completion: @escaping (Result<Void, Error>) -> Void) {
        let levelMO = LevelMO(context: container.viewContext)

        do {
            levelMO.id = UUID()
            levelMO.number = try self.fetchHighestNumber(levelType: .playable) + 1
            levelMO.gridText = level.gridText
            levelMO.letterMap = level.letterMap
            save()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
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
    
    func delete(levelID: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let request: NSFetchRequest<NSFetchRequestResult> = createFetchLevelRequest(resultType: NSFetchRequestResult.self, levelID: levelID)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    
    func saveLevel(level: Level, completion: @escaping (Result<Void, any Error>) -> Void) {
        do {
            var levelMO = try findLevel(id: level.id)
            
            if levelMO == nil {
                levelMO = LevelMO(context: container.viewContext)
                levelMO?.id = UUID()
                levelMO?.number = try self.fetchHighestNumber(levelType: level.levelType) + 1

//                levelMO.id = level.id
            }
            
            if let levelMO = levelMO {
                levelMO.gridText = level.gridText
                levelMO.letterMap = level.letterMap
                save()
                completion(.success(()))
            }
            else {
                completion(.failure(OptionalUnwrappingError.foundNil("Couldn't create LevelMO")))
            }
        }
        catch let error {
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
    

    var dbLocation: URL? {
        return container.persistentStoreCoordinator.persistentStores.first?.url
    }

    
    private let entityName: String = "LevelMO"
    
    private func createFetchLevelsRequest<T>(resultType: T.Type, levelType: Level.LevelType) -> NSFetchRequest<T> where T: NSFetchRequestResult {
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

    
    private func fetchHighestNumber(levelType: Level.LevelType) throws -> Int64 {
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
    
    
    func deleteAll(levelType: Level.LevelType) throws {
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
    

