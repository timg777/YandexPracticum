import UIKit


struct Movie: Codable {
    let title: String
    let rating: Int
    let imageUrl: URL
    
    var resizedImageUrl: URL {
        URL(string: imageUrl.absoluteString
            .replacingOccurrences(of: "V1_Ratio0.6716_AL", with: "V0_UX600" /*"V1"*/)) ?? imageUrl
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageUrl = "image"
    }
}




final class MoviesParser {
    public static let shared = MoviesParser()
    private init() {}
    
    @Sendable func parse(_ data: Data) async throws -> [Movie] {
        return []
    }
    
    @Sendable func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    @Sendable func encode<T: Encodable>(_ value: T) throws -> Data {
        return try JSONEncoder().encode(value)
    }
}











// MARK: - simple networking service layer




//{
//    "id":"tt0111161",
//    "rank":"1",
//    "title":"The Shawshank Redemption",
//    "fullTitle":"The Shawshank Redemption (1994)",
//    "year":"1994",
//    "image":"https://m.media-amazon.com/images/M/MV5BMDAyY2FhYjctNDc5OS00MDNlLThiMGUtY2UxYWVkNGY2ZjljXkEyXkFqcGc@._V1_.jpg",
//    "crew":""
//    ,"imDbRating":"9.3"
//    ,"imDbRatingCount":"3006130"
//}

struct NWConfig {
//    https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf
    static let webProtocol = "https://"
    static let websocket = "htv-api.com/"
    static let lang = "en/"
    static let apiKey = "k_zcuw1ytf"
    static let defaultPagePath = "API/"
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
    
    // MARK: - примерочный вариант загрузки данных, минуя декод и парсинг
    @Sendable func testFetch() -> [QuizQuestionModel] {
        return [
            
            .init(
                image: .theGodfather,
                question: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true
            ),
            .init(
                image: .theDarkKnight,
                question: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true
            ),
            .init(
                image: .killBill,
                question: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true
            ),
            .init(
                image: .theAvengers,
                question: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true
            ),
            .init(
                image: .deadpool,
                question: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true
            ),
            .init(
                image: .theGreenKnight,
                question: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true
            ),
            .init(
                image: .old,
                question: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false
            ),
            .init(
                image: .theIceAgeAdventuresOfBuckWild,
                question: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false
            ),
            .init(
                image: .tesla,
                question: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false
            ),
            .init(
                image: .vivarium,
                question: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false
            ),
            
        ]
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
    
    enum Module: String {
        case Top250TVs
        case MostPopularMovies
        case MostPopularTVs
        case InTheaters
        case ComingSoon
        case BoxOffice
        case BoxOfficeAllTime
        case Name
        case NameAwards
        case Company
        case Keyword
        
        var path: String {
            "/\(rawValue)"
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
private extension NWService {
    
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
