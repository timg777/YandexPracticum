import Foundation

protocol MovieQuizDataManager {
    var delegate: MovieQuizDataManagerDelegate? { get set }
    var loader: (any NWServiceProtocol)? { get }
    var parser: (any MovieQuizModelParserProtocol)? { get }
    func loadMovies()
    func loadImage(url: URL)
}
