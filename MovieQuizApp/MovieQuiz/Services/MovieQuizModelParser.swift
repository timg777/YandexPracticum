import Foundation

final class MovieQuizModelParser: MovieQuizModelParserProtocol {

    func decode(_ data: Data) throws -> MostPopularMovies {
        try JSONDecoder().decode(MostPopularMovies.self, from: data)
    }
    
}
