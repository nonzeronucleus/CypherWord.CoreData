import CoreData

class LevelDataService {
    @Published fileprivate(set) var levels: [Level] = []
    @Published fileprivate(set) var layouts: [Level] = []
    
    static var shared:LevelDataService = LevelDataServiceImpl()
    
    init() {
    }
    
    func addPlayableLevel() {
        fatalError("This method must be overridden")
    }
    
    func addLayout() {
        fatalError("This method must be overridden")
    }
    
    func addLevelFromData(level:Level) {
        fatalError("This method must be overridden")
    }

    func deleteAll(levelType: Level.LevelType) {
        fatalError("This method must be overridden")
    }
    
    func updateLevel(level:Level) {
        fatalError("This method must be overridden")
    }
}

class LevelDataServiceImpl : LevelDataService {

    override init() {
        container = NSPersistentContainer(name: containerName)
        
        super.init( )
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.populateLevels(levelType:.layout)
            self.populateLevels(levelType:.playable)
        }
        
        importLevels(levelType:.layout)
        importLevels(levelType:.playable)
    }
    
    
    // MARK - Public
    
    override func addPlayableLevel() {
        let entity = LevelMO(context: container.viewContext)
        entity.id = UUID()
        entity.number = Int64(getMaxLevelNumber(levelType: .playable)+1)
        entity.gridText = ""
        entity.letterMap = ""
        applyChanges(levelType: .playable)
    }
    
    override func addLayout() {
        let entity = LevelMO(context: container.viewContext)
        entity.id = UUID()
        entity.number = Int64(getMaxLevelNumber(levelType: .layout)+1)
        entity.gridText = nil
        entity.letterMap = nil
        applyChanges(levelType: .layout)
    }

    
    override func addLevelFromData(level:Level) {
        let entity = LevelMO(context: container.viewContext)
        entity.id = level.id
        entity.number = Int64(level.number)
        entity.gridText = level.gridText
        entity.letterMap = level.letterMap ?? ""
        applyChanges(levelType: .playable)
    }
    
    override func deleteAll(levelType: Level.LevelType) {
        let request: NSFetchRequest<NSFetchRequestResult> = createFetchRequest(resultType: NSFetchRequestResult.self, levelType: levelType)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
            self.populateLevels(levelType:.layout)
            self.populateLevels(levelType:.playable)
        } catch let error {
            print("Error deleting all levels. \(error)")
        }
    }
    
    override func updateLevel(level:Level) {
        guard let entity = getLevelMO(id: level.id) else { return }
        entity.number = Int64(level.number)
        entity.gridText = level.gridText
        entity.letterMap = level.letterMap
        applyChanges(levelType: level.levelType)
    }
    
    // MARK - Private
    
    private let container: NSPersistentContainer
    private let containerName: String = "LevelsContainer"
    private let entityName: String = "LevelMO"
    
    private func getLevelMO(id: UUID) -> LevelMO? {
        let request: NSFetchRequest<LevelMO> = createFetchRequest(resultType: LevelMO.self, levelType: .playable)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? container.viewContext.fetch(request).first
    }
    
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
    
    private func loadLevels(levelType:Level.LevelType) -> [Level] {
        do {
            let fetchRequest: NSFetchRequest<LevelMO> = createFetchRequest(resultType: LevelMO.self, levelType: levelType)
            print("Fetch Request \(fetchRequest)")
            let savedEntities = try container.viewContext.fetch(fetchRequest)
            
            let levels = savedEntities.map( {
                entity in Level(id: entity.id ?? UUID(), number: Int(entity.number), gridText: entity.gridText, letterMap: entity.letterMap)
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
        if levelType == .layout {
            return layouts.max(by: { $0.number < $1.number })?.number ?? 0
        }
        else {
            return levels.max(by: { $0.number < $1.number })?.number ?? 0
        }
    }
    
    private func importLevels(levelType:Level.LevelType) {
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
