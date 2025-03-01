class FilesUseCase {
    var fileRepository: SaveableRepositoryProtocol
    
    init(fileRepository: SaveableRepositoryProtocol) {
        self.fileRepository = fileRepository
    }
}
