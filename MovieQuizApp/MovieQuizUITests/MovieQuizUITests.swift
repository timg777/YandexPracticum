import XCTest
@testable import MovieQuiz

// MARK: - UI Tests
final class MovieQuizUITests: XCTestCase {
    
    // MARK: - Private Constants
    private let alertTitleIdentifier = "Этот раунд окончен!"
    private let alertOKButtonIdentifier = AccessibilityElement.alertOKButton.identifier
    private let counterLabel = AccessibilityElement.dynamicQuizCounterLabel.identifier
    private let positiveButtonElementName = AccessibilityElement.positiveButton.identifier
    private let negativeButtonElementName = AccessibilityElement.negativeButton.identifier
    private let filmCoverLabel = AccessibilityElement.dynamicFilmCoverView.identifier
    
    // MARK: - Current App
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launchArguments += ["UI-Testing"]
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    // MARK: - Test Cases
    @MainActor
    func testScreenCastPositiveButtonTapped() throws {
        try screenCastTest(positiveButtonElementName)
    }
    
    @MainActor
    func testScreenCastNegativeButtonTapped() throws {
        try screenCastTest(negativeButtonElementName)
    }
    
    @MainActor
    func testIndexChangePositiveButtonTapped() throws {
        try indexChangeTest(positiveButtonElementName)
    }
    
    @MainActor
    func testIndexChangeNegativeButtonTapped() throws {
        try indexChangeTest(negativeButtonElementName)
    }
    
    @MainActor
    func testButtonsAvaialabilityOnAnimationTime() throws {
        
        let positiveButtonElementName = AccessibilityElement.positiveButton.identifier
        let negativeButtonElementName = AccessibilityElement.negativeButton.identifier
        
        let firstButtonsAvaialableState =
        app.buttons[positiveButtonElementName].isEnabled && app.buttons[negativeButtonElementName].isEnabled
        XCTAssertTrue(firstButtonsAvaialableState, "buttons available state must be true at start")
        
        app.buttons[positiveButtonElementName].tap()
        let positiveButtonAvailabilityState = app.buttons[positiveButtonElementName].isEnabled
        let negativeButtonAvailabilityState = app.buttons[negativeButtonElementName].isEnabled
        let secondButtonsAvaialableState = positiveButtonAvailabilityState && negativeButtonAvailabilityState
        XCTAssertFalse(secondButtonsAvaialableState, "buttons available state must be false after screen cast")
        sleep(2)
        
        let thirdButtonsAvaialableState =
        app.buttons[positiveButtonElementName].isEnabled && app.buttons[negativeButtonElementName].isEnabled
        XCTAssertTrue(thirdButtonsAvaialableState, "buttons available state must be true after animation")
        
        XCTAssertEqual(
            firstButtonsAvaialableState,
            thirdButtonsAvaialableState,
            "buttons available state must be equal"
        )
        XCTAssertNotEqual(
            secondButtonsAvaialableState,
            firstButtonsAvaialableState,
            "buttons available state must be not equal"
        )
        XCTAssertNotEqual(
            secondButtonsAvaialableState,
            thirdButtonsAvaialableState,
            "buttons available state must be not equal"
        )
    }
    
    @MainActor
    func testAlertPresentedAfterEndedGame() throws {
        try checkAlertExists(false)
        try tapButtonsWhileAlertNotPresented()
        try checkAlertExists(true)
        try validateAlert()
        
        let firstCounterLabel = app.staticTexts[counterLabel].label
        XCTAssertEqual(firstCounterLabel, "10/10", "counter label must be 10/10 on end")
        
        app.alerts[alertTitleIdentifier].buttons.allElementsBoundByIndex[0].tap()
        try checkAlertExists(false)
        
        let secondCounterLabel = app.staticTexts[counterLabel].label
        XCTAssertNotEqual(firstCounterLabel, secondCounterLabel, "counter label must be different on end and on start")
        XCTAssertEqual(secondCounterLabel, "1/10", "counter label must be 1/10 on start")
    }
}

// MARK: - Extensions + Private Helpers
private extension MovieQuizUITests {
    
    @MainActor
    func screenCastTest(_ buttonName: String) throws {
        sleep(2)
        
        let firstPoster = app.images[filmCoverLabel]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons[buttonName].tap()
        
        sleep(2)
        
        let secondPoster = app.images[filmCoverLabel]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData, "images must be different")
    }
    
    @MainActor
    func indexChangeTest(_ buttonName: String) throws {
        sleep(2)
        
        let firstIndexLabel = app.staticTexts[counterLabel].label
        app.buttons[buttonName].tap()
        
        sleep(2)
        
        let secondIndexLabel = app.staticTexts[counterLabel].label
        
        XCTAssertNotEqual(firstIndexLabel, secondIndexLabel, "counter index must be different")
    }
    
    @MainActor
    func checkAlertExists(_ exists: Bool) throws {
        sleep(2)
        let alert = app.alerts[alertTitleIdentifier]
        XCTAssertEqual(alert.exists, exists, "alert must \(exists ? "exist" : "not exist")")
    }
    
    @MainActor
    func tapButtonsWhileAlertNotPresented() throws {
        for _ in 0..<10 {
            app.buttons[["Yes", "No"].randomElement() ?? "Yes"].tap()
            sleep(2)
        }
    }
    
    @MainActor
    func validateAlert() throws {
        sleep(2)
        let secondAlert = app.alerts[alertTitleIdentifier]
        XCTAssertTrue(secondAlert.exists, "alert must exist")
        
        let titleText = secondAlert.label
        XCTAssertEqual(titleText, alertTitleIdentifier, "alert title must be correct")
        
        let messageText = secondAlert.staticTexts.allElementsBoundByIndex[1].label
        
        let alertMessageTextIsValid = isMessageValid(message: messageText)
        XCTAssertTrue(alertMessageTextIsValid, "alert message must be correct")
        
        let okButton = secondAlert.buttons[alertOKButtonIdentifier]
        XCTAssertEqual(okButton.label, "Сыграть еще раз", "ok button label must be correct")
    }
    
    @MainActor
    func isMessageValid(message: String) -> Bool {
        let currentDateTimeString = Date().dateTimeString
        
        let pattern = """
        Ваш результат: .* /10\\s*
        Количество сыгранных квизов: 1\\s*
        Рекорд: .* \\(\(NSRegularExpression.escapedPattern(for: currentDateTimeString))\\)\\s*
        Средняя точность: .*%
        """
        
        let message = message.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        let trimmedPattern = pattern.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        
        let regex = try? NSRegularExpression(pattern: trimmedPattern, options: .anchorsMatchLines)
        
        let range = NSRange(location: 0, length: message.utf16.count)
        return regex?.firstMatch(in: message, options: [], range: range) != nil
    }
}
