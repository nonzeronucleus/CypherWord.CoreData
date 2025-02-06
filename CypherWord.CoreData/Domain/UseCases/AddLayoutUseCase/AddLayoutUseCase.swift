import Foundation

class AddLayoutUseCase: AddLayoutUseCaseProtocol {
    // Inject repository or data provider
    private let repository: LevelRepositoryProtocol

    init(repository: LevelRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[Level], Error>) -> Void) {
        repository.addLayout(completion: completion)
    }
}
