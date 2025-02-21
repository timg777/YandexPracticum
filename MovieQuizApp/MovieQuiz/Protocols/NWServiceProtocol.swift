import Foundation

protocol NWServiceProtocol {
    func fetchMovies(_ handler: @escaping (Result<Data, Error>) -> Void)
    func fetchImage(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
