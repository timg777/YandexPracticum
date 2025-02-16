import Foundation


extension URLResponse {
    var getHTTPResponseCode: Int? {
        (self as? HTTPURLResponse)?.statusCode
    }
}
