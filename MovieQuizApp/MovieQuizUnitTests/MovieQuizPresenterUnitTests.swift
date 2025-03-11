@testable import MovieQuiz
import XCTest

// TODO: - implement presenter hard tests
final class MovieQuizPresenterUnitTests: XCTestCase {
    
    var mockViewController: MovieQuizMockViewController!
    var stubNetworkService: StubNetowrkClient!
    var presenter: MovieQuizPresenter!
    
    override func setUp() {
        mockViewController = .init()
        super.setUp()
    }
    
    override func tearDown() {
        mockViewController = nil
        super.tearDown()
    }
    
    func testButtonTappedHandler() {
        // Given
        let stubNetworkService = StubNetowrkClient(emulateError: false)
        let presenter = MovieQuizPresenter(
            viewController: mockViewController,
            networkService: stubNetworkService
        )
        
        // TODO: - implement button hundler unit test
        // When
//        let expectation = expectation(description: "Buttons tapped waiting")
//        mockViewController.actionCallBack = {
//            expectation.fulfill()
//        }
        
//        // MARK: - pre check
//        XCTAssertTrue(mockViewController.isUserInteractionEnabledForButtons)
//        XCTAssertTrue(mockViewController.loadingIndicatorIsHidden)
//        XCTAssertNil(mockViewController.filmCoverBorderColor)
//        
//        presenter.handleButtonTapped(true)
//        
//        // MARK: - check after positive button tapped and before new question generated
//        XCTAssertFalse(mockViewController.isUserInteractionEnabledForButtons)
//        XCTAssertFalse(mockViewController.loadingIndicatorIsHidden)
//        XCTAssertEqual(mockViewController.filmCoverBorderColor, UIColor.ysGreen.cgColor)
//        
//        DispatchQueue.main.asyncAfter(
//            deadline: .now() + GlobalConfig.waitTimeForButtonsUnlock.rawValue
//        ) { [weak self] in
//            guard let self = self else { XCTAssertThrowsError("class deinitialized before assert"); return }
//            XCTAssertFalse(mockViewController.isUserInteractionEnabledForButtons)
//            XCTAssertTrue(mockViewController.loadingIndicatorIsHidden)
//            XCTAssertNil(mockViewController.filmCoverBorderColor)
//        }
        
        // Then
        
//        let isCorrectAnswer = currentQuestion?.correctAnswer == isPositiveButton
//        
//        statisticService?.incCurrentQuestionIndex()
//        isCorrectAnswer ? statisticService?.incCurrentCorrectAnswers() : nil
//        
//        UIView.animate( withDuration: 0.3 ) { [weak self] in
//            self?.viewController?.setBorderColorForDynamicFilmCoverView(isCorrectAnswer: isCorrectAnswer)
//        }
//        
//        viewController?.switchButtonsAvailableState()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, qos: .userInteractive) { [weak self] in
//            guard let self else { return }
//            UIView.animate( withDuration: 0.3 ) { [weak self] in
//                self?.viewController?.hideFilmCoverBorder()
//            }
//            viewController?.switchButtonsAvailableState()
//            questionFactory?.requestQuestion(statisticService?.currentGame.questionIndex ?? 0)
//        }
    }
    
    // TODO: - implement alert presented unit test
    func testAlertPresented() {}
    // TODO: - implement error occured scenario unit test
    func testAnErrorOccuredScenario() {}
}
