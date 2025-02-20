import UIKit

// https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf

protocol NWServiceProtocol {
    func fetch(_ handler: @escaping (Result<Data, Error>) -> Void)
}

final class NWService: NWServiceProtocol {
    
    func fetch(_ handler: @escaping (Result<Data, Error>) -> Void) {
        
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
               !(200..<300).contains(response.statusCode) {
                handler(.failure(MovieQuizError.invalidResponse))
                return
            }
            
            guard let data = data else {
                handler(.failure(MovieQuizError.invalidData))
                return
            }
            handler(.success(data))
        }
        
        task.resume()
    }
    
}

// MARK: - private builders
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
    
    private func buildRequest( url: URL) -> URLRequest {
        var request = URLRequest( url: url )
        
        request.httpMethod = "GET"
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type" )
        request.httpBody = nil
        request.setValue( "some-payload", forHTTPHeaderField: "value" )
        
        return request
    }
    
    private enum NWConfig: String {
        case websocket = "https://tv-api.com/"
        case lang = "en/"
        case concreteModule = "API/"
        case apiKey = "/k_zcuw1ytf"
    }
    
}
