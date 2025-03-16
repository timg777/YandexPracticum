import Foundation

// MARK: - Extensions + Internal Array Safe Index Subscript
extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
    
    subscript(safe range: Range<Int>) -> [Element]? {
        indices ~= range.lowerBound && indices ~= range.upperBound ? Array(self[range]) : nil
    }
    
    subscript(safe closedRange: ClosedRange<Int>) -> [Element]? {
        indices ~= closedRange.lowerBound && indices ~= closedRange.upperBound ? Array(self[Range(closedRange)]) : nil
    }
}
