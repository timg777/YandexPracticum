import Foundation

protocol MovieQuizModelParserProtocol {
    func decode(_ data: Data) throws -> MostPopularMovies
}
