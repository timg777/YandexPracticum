import UIKit


extension UILabel {

    func setAttributedText( font: UIFont ) {
        self.attributedText = self.text?.getAttributedString( font: font, color: UIColor.white! )
    }
    
}
