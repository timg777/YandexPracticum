import Foundation

final class DataManager: DataRouting {
    
    weak var delegate: DataManagerDelegate?
    var loader: (any NWServiceProtocol)?
    var parser: (any ModelParserProtocol)?
    
    init(
        loader: (any NWServiceProtocol)?,
        parser: (any ModelParserProtocol)?,
        delegate: DataManagerDelegate?
    ) {
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
