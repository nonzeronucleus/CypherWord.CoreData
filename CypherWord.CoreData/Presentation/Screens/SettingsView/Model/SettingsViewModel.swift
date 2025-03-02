import Foundation
import Dependencies
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    let id = UUID()
    private let updateSettingsUseCase: UpdateSettingsUseCaseProtocol
    private let loadSettingsUseCase: LoadSettingsUseCaseProtocol

    // Save settings whenever they change
    @Published var settings: Settings {
        didSet {
            updateSettingsUseCase.execute(settings)
        }
    }
    
    

    init(
        parentId: UUID?,
        updateSettingsUseCase: UpdateSettingsUseCaseProtocol = UpdateSettingsUseCase(repository: Dependency(\.settingsRepository).wrappedValue),
        loadSettingsUseCase: LoadSettingsUseCaseProtocol = LoadSettingsUseCase(repository: Dependency(\.settingsRepository).wrappedValue)
    ) {
        print("\(String(describing: parentId))")
        self.updateSettingsUseCase = updateSettingsUseCase
        self.loadSettingsUseCase = loadSettingsUseCase
        let settings = loadSettingsUseCase.execute()
        self.settings = settings
    }
}
