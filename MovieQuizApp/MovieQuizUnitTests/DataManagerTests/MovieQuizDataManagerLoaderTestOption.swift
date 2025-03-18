enum DataManagerLoaderTestOption {
    case successFilms
    case failedFilms
    case successImage
    case failedImage
    
    var emulateError: Bool {
        switch self {
        case .failedFilms, .failedImage:
            return true
        default:
            return false
        }
    }
    
    var isFilmLoader: Bool {
        switch self {
        case .failedFilms, .successFilms:
            return true
        case .failedImage, .successImage:
            return false
        }
    }
}
