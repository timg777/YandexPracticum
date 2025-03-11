import Foundation

final class ModelParser: ModelParserProtocol {

    func decode(_ data: Data) throws -> MostPopularMovies {
        try JSONDecoder().decode(MostPopularMovies.self, from: data)
    }
    
}
