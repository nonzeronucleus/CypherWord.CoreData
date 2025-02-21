import Foundation
import Dependencies
import Combine

class SettingsViewModel {
    private let updateSettingsUseCase: UpdateSettingsUseCaseProtocol
    private let loadSettingsUseCase: LoadSettingsUseCaseProtocol

    var settings: Settings = Settings() {
        didSet {
            updateSettingsUseCase.execute(settings)
        }
    }

    init(
        updateSettingsUseCase: UpdateSettingsUseCaseProtocol = UpdateSettingsUseCase(repository: Dependency(\.settingsRepository).wrappedValue),
        loadSettingsUseCase: LoadSettingsUseCaseProtocol = LoadSettingsUseCase(repository: Dependency(\.settingsRepository).wrappedValue)
    ) {
        self.updateSettingsUseCase = updateSettingsUseCase
        self.loadSettingsUseCase = loadSettingsUseCase
        self.settings = loadSettingsUseCase.execute()
    }

    func toggleEditMode() {
        settings.editMode.toggle()
    }

    func toggleShowCompletedLevels() {
        settings.showCompletedLevels.toggle()
    }
}
