@testable import MovieQuiz
import XCTest

// MARK: - Date Unit Tests
final class DateTests: XCTestCase {
    
    func testDateTimeString() throws {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY hh:mm"
        
        // When
        let date = Date()
        let expectedDateTimeString = dateFormatter.string(from: date)
        let testDateTimeString = date.dateTimeString
        
        // Then
        XCTAssertEqual(testDateTimeString, expectedDateTimeString)
    }

}
