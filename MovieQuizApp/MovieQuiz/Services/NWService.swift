import UIKit


// MARK: - simple networking service layer


struct NWConfig {
    static let websocket = "https://world-wide-films.com/"
    static let apiKey = "md5/sha256"
    static let defaultPagePath = "/popular"
}



// MARK: - необходимо написать еще мониториг сетевого соединения по типу:
/**
 import Network
 
 NWPathMonitor().pathUpdateHandler = { path in
     // MARK: - switch pathes and react
 }
 **/
// MARK: - мы можем расширять функциионал, не изменяя его
@preconcurrency
final class NWService {
    
    public static let shared = NWService()
    let nwFlow = DispatchQueue(label: "com.YandexPracticum.MovieQuiz.nwFlow", qos: .userInitiated)
    
    // MARK: - property wrapperом @Sendable мы гарантиируем, что данная функция является потокобезопасной, что позволяет деражть ее в бэкграунде
    @Sendable func fetch( method: HTTPMethod, module: Module ) async -> Result<Data, NWError> {
        
        guard let url = buildURL( module: module ) else {
            return .failure( .invalidURL )
        }
        let request = buildRequest( url: url, method: method )
        
        guard let result = try? await URLSession.shared.data(for: request) else {
            return .failure( .invalidResponse )
        }
        
        // MARK: - сильно пока не болит голова по обработке конкретных ситуаций - позже, сейчас накидал дефолтный сервис
        
        return .success( result.0 )
        
    }

    
}


// MARK: - object helpers
extension NWService {
    
    enum NWError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }
    
    enum HTTPMethod: String {
        case GET = "GET"
//        case POST = "POST"
//        case PUT = "PUT"
//        case DELETE = "DELETE"
    }
    
    enum Module {
        case films
//        case users
//        case etc
        
        var path: String {
            switch self {
                case .films: return "/films"
            }
        }
    }
    
    enum HTTPStatus: Int16 {
        case ok = 200
        case badRequest = 400
        case unauthorized = 401
        case notFound = 404
        case internalServerError = 500
    }
    
}


// MARK: - helpers
extension NWService {
    
    func buildURL( module: Module ) -> URL? {
        URL( string: NWConfig.websocket + module.path + NWConfig.defaultPagePath + "api_key=\(NWConfig.apiKey)" )
    }
    
    func buildRequest( url: URL, method: HTTPMethod ) -> URLRequest {
        var request = URLRequest( url: url )
        
        request.httpMethod = method.rawValue
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type" )
        request.httpBody = nil
        request.setValue( "some-payload", forHTTPHeaderField: "value" )
        
        return request
    }
    
}
