import UIKit

final class NWService: NWServiceProtocol {
    // MARK: - NWService stuff here
}

// MARK: - Extensions + Internal Methods
extension NWService {
    func fetchMovies(_ handler: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = buildURL() else {
            handler(.failure(MovieQuizError.invalidURL))
            return
        }
        let request = buildRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               (200..<300).contains(response.statusCode) {
                
                if let data = data {
                    handler(.success(data))
                } else {
                    handler(.failure(MovieQuizError.invalidData))
                    return
                }
                
            } else {
                handler(.failure(MovieQuizError.invalidResponse))
                return
            }
            
        }
        
        task.resume()
    }
    
    func fetchImage(url: URL, handler: @escaping (Result<Data, any Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               (200..<300).contains(response.statusCode) {
                
                if let data = data {
                    handler(.success(data))
                } else {
                    handler(.failure(MovieQuizError.invalidData))
                    return
                }
            } else {
                handler(.failure(MovieQuizError.invalidImageURL))
            }
        }
        
        task.resume()
    }
}

// MARK: - Extensions + Private Builders
extension NWService {
    
    private func buildURL() -> URL? {
        URL( string:
                NWConfig.websocket.rawValue +
             NWConfig.lang.rawValue +
             NWConfig.concreteModule.rawValue +
             "Top250Movies" +
             NWConfig.apiKey.rawValue
        )
    }
    
    private func buildRequest(url: URL) -> URLRequest {
        var request = URLRequest( url: url )
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    private enum NWConfig: String {
        case websocket = "https://tv-api.com/"
        case lang = "en/"
        case concreteModule = "API/"
        case apiKey = "/k_zcuw1ytf"
    }
    
}
