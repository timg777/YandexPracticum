import Foundation

final class DataManager: DataRouting {
    
    // MARK: - Internal Properties
    weak var delegate: DataManagerDelegate?
    
    var loader: (any NWServiceProtocol)?
    var parser: (any ModelParserProtocol)?
    
    // MARK: - Internal Initializer
    init(
        loader: (any NWServiceProtocol)?,
        parser: (any ModelParserProtocol)?,
        delegate: DataManagerDelegate?
    ) {
        self.delegate = delegate
        self.loader = loader
        self.parser = parser
    }
    
}

// MARK: - Extensions + Internal Methods
extension DataManager {
    
    func loadMovies() {
        loader?.fetchMovies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                do {
                    if let movies = try parser?.decode(data) {
                        DispatchQueue.main.async { [weak self] in
                            if !movies.errorMessage.isEmpty {
                                self?.delegate?.didReceiveError(MovieQuizError.serverErrorMessage(movies.errorMessage))
                            } else {
                                if !movies.items.isEmpty {
                                    self?.delegate?.didReceiveMovies(movies.items)
                                } else {
                                    self?.delegate?.didReceiveError(MovieQuizError.noDataHasProvided("There is no data"))
                                }
                            }
                        }
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.didReceiveError(MovieQuizError.decodeError("Decoding error"))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didReceiveError(MovieQuizError.unknown(error.localizedDescription))
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
                    self?.delegate?.didReceiveError(MovieQuizError.invalidImageURL(error.localizedDescription))
                }
            }
        }
    }
    
}
