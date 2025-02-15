import UIKit


extension String {
    
    func getAttributedString( font: UIFont, color: UIColor ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.setAttributes(
            [
                .font: font,
                .foregroundColor: color,
            ],
            range: NSRange(location: 0, length: attributedString.length)
        )
        return attributedString
    }
    
}
