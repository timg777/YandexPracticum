import XCTest
@testable import MovieQuiz

// MARK: - ArrayTests
final class ArrayTests: XCTestCase {
    
    // Given
    let array = [1, 2, 3, 4, 5, 6, 7, 8]
    
    func testGetValueInBounds() throws {
        // When
        let value = array[safe: 3]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 4)
    }
    
    func testGetValueOutOfBounds() throws {
        // When
        let value = array[safe: 10]
        
        // Then
        XCTAssertNil(value)
    }
    
    func testGetAarrayInBoundsByRange() throws {
        // When
        let value = array[safe: 1..<5]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, [2, 3, 4, 5])
    }
    
    func testGetArrayOutOfBoundsByRange() throws {
        // When
        let value = array[safe: 8...15]
        
        // Then
        XCTAssertNil(value)
    }
    
    func testGetArrayInBoundsByClosedRange() throws {
        // When
        let value = array[safe: 1...3]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, [2, 3, 4])
    }
    
    func testGetArrayOutOfBoundsByClosedRange() throws {
        // When
        let value = array[safe: 5...10]
        
        // Then
        XCTAssertNil(value)
    }

}
