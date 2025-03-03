class FilesUseCase {
    var fileRepository: FileRepositoryProtocol
    
    init(fileRepository: FileRepositoryProtocol) {
        self.fileRepository = fileRepository
    }
}
