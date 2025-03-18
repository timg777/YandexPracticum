import XCTest
@testable import MovieQuiz

// MARK: - Array Unit Tests
final class ArrayTests: XCTestCase {
    
    // Given
    // MARK: - Private Constants
    private let array = [1, 2, 3, 4, 5, 6, 7, 8]
    
    // MARK: - Test Cases
    func testGetValueInBounds() throws {
        // When
        let value = array[safe: 3]
        
        // Then
        XCTAssertNotNil(value, "value must not be nil")
        XCTAssertEqual(value, 4, "values must be equal")
    }
    
    func testGetValueOutOfBounds() throws {
        // When
        let value = array[safe: 10]
        
        // Then
        XCTAssertNil(value, "value must be nil")
    }
    
    func testGetAarrayInBoundsByRange() throws {
        // When
        let value = array[safe: 1..<5]
        
        // Then
        XCTAssertNotNil(value, "value must not be nil")
        XCTAssertEqual(value, [2, 3, 4, 5], "arrays must be equal")
    }
    
    func testGetArrayOutOfBoundsByRange() throws {
        // When
        let value = array[safe: 8...15]
        
        // Then
        XCTAssertNil(value, "value must be nil")
    }
    
    func testGetArrayInBoundsByClosedRange() throws {
        // When
        let value = array[safe: 1...3]
        
        // Then
        XCTAssertNotNil(value, "value must not be nil")
        XCTAssertEqual(value, [2, 3, 4], "arrays must be equal")
    }
    
    func testGetArrayOutOfBoundsByClosedRange() throws {
        // When
        let value = array[safe: 5...10]
        
        // Then
        XCTAssertNil(value, "value must be nil")
    }

}
