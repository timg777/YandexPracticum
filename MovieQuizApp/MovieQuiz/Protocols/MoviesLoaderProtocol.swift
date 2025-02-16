

protocol MoviesLoaderProtocol {
    @Sendable func load() async throws -> Data
}
