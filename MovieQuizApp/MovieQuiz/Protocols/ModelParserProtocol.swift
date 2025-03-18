import Foundation

protocol ModelParserProtocol {
    func decode(_ data: Data) throws -> MostPopularMovies
}
