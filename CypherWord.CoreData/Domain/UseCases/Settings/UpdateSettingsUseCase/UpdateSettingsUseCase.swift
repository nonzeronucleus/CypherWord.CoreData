import Foundation
import Dependencies

final class UpdateSettingsUseCase: UpdateSettingsUseCaseProtocol {
    private let repository: SettingsRepositoryProtocol

    init(repository: SettingsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(_ settings: Settings) {
        repository.saveSettings(settings)
    }
}
