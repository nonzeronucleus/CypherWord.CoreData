import Foundation

final class SettingsRepository: SettingsRepositoryProtocol {
    private let userDefaults = UserDefaults.standard
    private let settingsKey = "app_settings"

    func loadSettings() -> Settings {
        if let data = userDefaults.data(forKey: settingsKey) {
            if let settings = try? JSONDecoder().decode(Settings.self, from: data) {
                return settings
            }
            return Settings(showCompletedLevels: true, editMode: true)
        }
        return Settings(showCompletedLevels: true, editMode: true)
    }

    func saveSettings(_ settings: Settings) {
        if let data = try? JSONEncoder().encode(settings) {
            userDefaults.set(data, forKey: settingsKey)
        }
    }
}
