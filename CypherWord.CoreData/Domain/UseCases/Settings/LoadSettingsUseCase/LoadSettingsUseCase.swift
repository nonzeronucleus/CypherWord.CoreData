import Foundation
import Dependencies

final class LoadSettingsUseCase: LoadSettingsUseCaseProtocol {
//    @Dependency(\.settingsRepository) private var settingsRepository: SettingsRepositoryProtocol

    private let repository: SettingsRepositoryProtocol

    init(repository: SettingsRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> Settings {
        return repository.loadSettings()
    }
}

