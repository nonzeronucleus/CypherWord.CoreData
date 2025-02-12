import Foundation

protocol DeleteLevelUseCaseProtocol {
    func execute(levelID: UUID, completion: @escaping (Result<Void, any Error>) -> Void) 
}
