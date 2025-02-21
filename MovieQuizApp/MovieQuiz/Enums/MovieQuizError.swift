enum MovieQuizError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unknown
    case decodeError
    case invalidImageURL
    case noDataHasProvided
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            "An invalid URL was provided"
        case .invalidResponse:
            "The server did not return a valid HTTP response"
        case .invalidData:
            "No data was returned from the server"
        case .decodeError:
            "There was an error decoding the JSON data"
        case .unknown:
            "An unknown error occurred"
        case .invalidImageURL:
            "There was an error converting the URL to an Image"
        case .noDataHasProvided:
            "No data has been provided"
        @unknown default:
            "An unknown error occurred"
        }
    }
}
