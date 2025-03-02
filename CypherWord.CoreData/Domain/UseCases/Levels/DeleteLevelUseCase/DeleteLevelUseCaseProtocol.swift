import Foundation

protocol DeleteLevelUseCaseProtocol {
    func execute(levelID: UUID) async throws
}
