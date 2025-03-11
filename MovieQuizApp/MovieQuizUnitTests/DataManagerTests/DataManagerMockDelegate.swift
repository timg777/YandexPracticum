@testable import MovieQuiz
import Foundation

final class DataManagerMockDelegate: DataManagerDelegate {
    var didFailLoadingCalled = false
    var didReceiveImageDataCalled = false
    var didReceiveMoviesCalled = false
    
    var didRecivedAnswerCallback: (() -> Void)?
    
    func didReceiveError(_ error: any Error) {
        didFailLoadingCalled = true
        didRecivedAnswerCallback?()
    }
    
    func didReceiveMovies(_ movies: [MovieQuiz.MostPopularMovie]) {
        didReceiveMoviesCalled = true
        didRecivedAnswerCallback?()
    }
    
    func didReceiveImageData(_ imageData: Data) {
        didReceiveImageDataCalled = true
        didRecivedAnswerCallback?()
    }
}
