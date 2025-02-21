import Foundation

final class MovieQuizDataManagerImplementation: MovieQuizDataManager {
    
    weak var delegate: MovieQuizDataManagerDelegate?
    var loader: (any NWServiceProtocol)?
    var parser: (any MovieQuizModelParserProtocol)?
    
    init(loader: (any NWServiceProtocol)?, parser: (any MovieQuizModelParserProtocol)?, delegate: MovieQuizDataManagerDelegate?) {
        self.delegate = delegate
        self.loader = loader
        self.parser = parser
    }
    
    func loadMovies() {
        loader?.fetchMovies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do {
                    let movies = try parser?.decode(data)
                    DispatchQueue.main.async { [weak self] in
                        if let items = movies?.items {
                            self?.delegate?.didReceiveMovies(items)
                        } else {
                            self?.delegate?.didReceiveError(MovieQuizError.noDataHasProvided)
                        }
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.didReceiveError(MovieQuizError.decodeError)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didReceiveError(error)
                }
            }
        }
    }
    
    func loadImage(url: URL) {
        loader?.fetchImage(url: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didReceiveImageData(data)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didReceiveError(error)
                }
            }
        }
    }
    
}
