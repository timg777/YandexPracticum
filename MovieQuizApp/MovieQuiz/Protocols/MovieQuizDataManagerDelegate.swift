import Foundation

protocol MovieQuizDataManagerDelegate: AnyObject {
    func didReceiveError(_ error: Error)
    func didReceiveMovies(_ movies: [MostPopularMovie])
    func didReceiveImageData(_ imageData: Data)
}
