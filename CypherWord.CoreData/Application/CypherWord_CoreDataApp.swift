import SwiftUI



@main
struct CypherWord_CoreDataApp: App {
    
    init() {
        UserDefaults.standard.register(defaults: [
            "ShowCompletedLevels": false,
            "EditMode": true
            ])
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
