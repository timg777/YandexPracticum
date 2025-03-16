import Foundation

// MARK: - Global Config Namespace
enum GlobalConfig: CGFloat {
    case buttonsCornerRadius = 15
    case posterCornerRadius = 20
    case filmCoverViewLayerBorderWidth = 8
    case filmCoverBorderViewWidth = 8.01

    case questionsAmount = 10
    case totalQuestionsAmount = 250
    
    case waitTimeForButtonsUnlock = 0.7
    case contentChangingAnimationTime = 0.3
    
    static func borderAnimationTime(picIsLoaded: Bool) -> CFTimeInterval {
        picIsLoaded ? 0.5 : 0.15
    }
    static func filmCoverViewLayerOpacity(picIsLoaded: Bool) -> Float {
        picIsLoaded ? 1 : 0.3
    }
}
