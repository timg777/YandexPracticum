import Foundation



struct MoviesLoader: MoviesLoaderProtocol {
    private let nw = NWService()
    @Sendable func load() async throws -> Data {
        switch await nw.fetch(method: .GET, module: .Top250TVs) {
        case .success(let data):
            data.
        case .failure(let error):
            #warning("TODO: handle errors")
        }
    }
}



