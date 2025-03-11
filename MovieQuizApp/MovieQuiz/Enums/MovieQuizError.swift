enum MovieQuizError: Error {
    
    case invalidURL(String)
    case invalidResponse(String)
    case invalidData(String)
    case decodeError(String)
    case invalidImageURL(String)
    case noDataHasProvided(String)
    case serverErrorMessage(String)
    case unknown(String)

}
