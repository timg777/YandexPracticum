@testable import MovieQuiz
import XCTest

// MARK: - DataManager Loader Unit Tests
final class DataManagerLoaderTests: XCTestCase {
    
    var parser: ModelParser!
    var mockDelegate: DataManagerMockDelegate!
    
    override func setUp() {
        parser = .init()
        mockDelegate = .init()
        super.setUp()
    }
    
    override func tearDown() {
        parser = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testSuccessMoviesLoading() throws {
        universalTestCase(.successFilms)
    }
    
    func testFailureMoviesLoading() throws {
        universalTestCase(.failedFilms)
    }
    
    func testSuccessImageLoading() throws {
        universalTestCase(.successImage)
    }
    
    func testFailureImageLoading() throws {
        universalTestCase(.failedImage)
    }
}

// MARK: - Extensions + Private Methods (universal method for all test cases)
private extension DataManagerLoaderTests {
    
    func universalTestCase(_ option: DataManagerLoaderTestOption) {
        // Given
        let stubNetworkClient = StubNetowrkClient(emulateError: option.emulateError)
        let dataManager = DataManager(loader: stubNetworkClient, parser: parser, delegate: mockDelegate)

        // When
        let expectation = expectation(description: "Loading expectation")
        
        mockDelegate.didRecivedAnswerCallback = {
            expectation.fulfill()
        }
        
        // MARK: - choosing loader
        if option.isFilmLoader {
            dataManager.loadMovies()
        } else {
            guard let safeURL = URL(string: "www.google.com") else { XCTAssertThrowsError("BAD_URL"); return }
            dataManager.loadImage(url: safeURL)
        }
        
        // Then
        waitForExpectations(timeout: 1) { [weak self] error in
            guard let self else { return }
            let isFailed = option == .failedFilms || option == .failedImage
            
            XCTAssertEqual(mockDelegate.didReceiveMoviesCalled, option == .successFilms ? true : false)
            XCTAssertEqual(mockDelegate.didFailLoadingCalled, isFailed ? true : false)
            XCTAssertEqual(mockDelegate.didReceiveImageDataCalled, option == .successImage ? true : false)
            XCTAssertNil(error)
        }
    }
}
