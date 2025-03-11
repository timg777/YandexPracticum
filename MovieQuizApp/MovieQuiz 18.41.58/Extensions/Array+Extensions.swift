import Foundation

// MARK: - array safe index subscript
extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
