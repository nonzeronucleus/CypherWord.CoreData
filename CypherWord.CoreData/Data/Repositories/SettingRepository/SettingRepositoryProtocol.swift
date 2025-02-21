protocol SettingsRepositoryProtocol {
    func loadSettings() -> Settings
    func saveSettings(_ settings: Settings)
}


