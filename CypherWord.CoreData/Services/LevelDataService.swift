import CoreData

class LevelDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "LevelsContainer"
    private let entityName: String = "LevelMO"
    
    @Published private(set) var levels: [Level] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.loadLevels()
        }
    }
    
    func loadLevels() {
        let request = NSFetchRequest<LevelMO>(entityName: entityName)
        do {
            let savedEntities = try container.viewContext.fetch(request)
            
            levels = savedEntities.map( {
                entity in Level(id: entity.id!, number: Int(entity.number), gridText: entity.gridText ?? "", letterMap: entity.letterMap ?? "")
            })
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
    
    func addLevel() {
        let entity = LevelMO(context: container.viewContext)
        entity.id = UUID()
        entity.number = Int64(getMaxLevelNumber()+1)
        entity.gridText = ""
        entity.letterMap = ""
        applyChanges()
    }
    
    func deleteAll() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
            levels.removeAll() // Clear the in-memory levels array
        } catch let error {
            print("Error deleting all levels. \(error)")
        }
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        loadLevels()
    }
    
    private func getMaxLevelNumber() -> Int {
//        return levels.max(by: { $0.number < $1.number })?.number ?? 0 + 1
        let max = levels.max(by: { $0.number < $1.number })?.number ?? 0
        
        print(max)
        
        return max
    }
}
