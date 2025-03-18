import UIKit

// MARK: - Extensions + Internal Colors
extension UIColor {
    static let black = UIColor(named: "Black")
    static let white = UIColor(named: "White")
    static let green = UIColor(named: "Green")
    static let gray = UIColor(named: "Gray")
    static let red = UIColor(named: "Red")
    
    static func filmCoverBorderColor(isCorrectAnswer: Bool) -> CGColor {
        isCorrectAnswer ? UIColor.ysGreen.cgColor : UIColor.ysRed.cgColor
    }
}
