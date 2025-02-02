import CoreData

class LevelDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "LevelsContainer"
    private let entityName: String = "LevelMO"
    
    @Published private(set) var levels: [Level] = []
    @Published private(set) var layouts: [Level] = []

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.populateLevels(levelType:.layout)
            self.populateLevels(levelType:.playable)
        }
        
//        importLevels(levelType:.layout)
        importLevels(levelType:.playable)
    }
    
    
    // MARK - Public
    
    func addPlayableLevel() {
        let entity = LevelMO(context: container.viewContext)
        entity.id = UUID()
        entity.number = Int64(getMaxLevelNumber(levelType: .playable)+1)
        entity.gridText = ""
        entity.letterMap = ""
        applyChanges(levelType: .playable)
    }
    
    func addLevelFromData(level:Level) {
        let entity = LevelMO(context: container.viewContext)
        entity.id = level.id
        entity.number = Int64(level.number)
        entity.gridText = level.gridText
        entity.letterMap = level.letterMap ?? ""
        applyChanges(levelType: .playable)
    }
    
    func deleteAll() {
        let request: NSFetchRequest<NSFetchRequestResult> = createFetchRequest(resultType: NSFetchRequestResult.self)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
            levels.removeAll() // Clear the in-memory levels array
        } catch let error {
            print("Error deleting all levels. \(error)")
        }
    }
    


    // MARK - Private
    
    private func createFetchRequest<T>(resultType: T.Type) -> NSFetchRequest<T> where T: NSFetchRequestResult {
        let request = NSFetchRequest<T>(entityName: entityName)
        request.predicate = NSPredicate(format: "letterMap != nil")
        request.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
        return request
    }
    
    private func loadLevels(levelType:Level.LevelType) -> [Level] {
        do {
            let fetchRequest: NSFetchRequest<LevelMO> = createFetchRequest(resultType: LevelMO.self)
            let savedEntities = try container.viewContext.fetch(fetchRequest)
            
            let levels = savedEntities.map( {
                entity in Level(id: entity.id ?? UUID(), number: Int(entity.number), gridText: entity.gridText ?? "", letterMap: entity.letterMap ?? "")
            })
            return levels
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
            return []
        }
    }
    

    

    private func save(levelType:Level.LevelType) {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges(levelType:Level.LevelType) {
        save(levelType: levelType)
        populateLevels(levelType: levelType)
    }
    
    private func populateLevels(levelType:Level.LevelType) {
        let newLevels = loadLevels(levelType: levelType)
        
        switch (levelType) {
            case .layout:
                layouts = newLevels
            case .playable:
                levels = newLevels
        }
    }
    
    private func getMaxLevelNumber(levelType:Level.LevelType) -> Int {
        return levels.max(by: { $0.number < $1.number })?.number ?? 0
    }
    
    private func importLevels(levelType:Level.LevelType) {
//        let docDir = URL.documentsDirectory
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            if let path = Bundle.main.url(forResource: levelType == .layout ? "Layout" :"Level", withExtension: "json") {
                
                let jsonData = try Data(contentsOf: path)
                let newLevels = try decoder.decode([Level].self, from: jsonData)
                
                for newLevel in newLevels {
                    if (levels.first { $0.id == newLevel.id } == nil) {
                        addLevelFromData(level: newLevel)
                    }
                }
                applyChanges(levelType: levelType)
            }
            else {
                print("No file found")
            }
        }
        catch {
            print("Error reading JSON file: \(error)")
        }
    }
}
