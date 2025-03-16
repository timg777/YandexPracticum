import Foundation

// MARK: - Extensions + Internal Helpers
extension Date {
    var dateTimeString: String { DateFormatter.defaultDateTime.string(from: self) }
}

// MARK: - Extensions + Private Helpers
private extension DateFormatter {
    static let defaultDateTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY hh:mm"
        return dateFormatter
    }()
}
