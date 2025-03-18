import Foundation

final class ModelParser: ModelParserProtocol {
    // MARK: - ModelParser stuff here
}

// MARK: - Extensions + Internal Methods
extension ModelParser {
    func decode(_ data: Data) throws -> MostPopularMovies {
        try JSONDecoder().decode(MostPopularMovies.self, from: data)
    }
}
