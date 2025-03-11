import Foundation

protocol DataRouting {
    var delegate: DataManagerDelegate? { get set }
    var loader: (any NWServiceProtocol)? { get }
    var parser: (any ModelParserProtocol)? { get }
    func loadMovies()
    func loadImage(url: URL)
}
