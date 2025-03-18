enum AccessibilityElement {
    
    case staticQuestionLabel
    case dynamicQuestionLabel
    case dynamicFilmCoverView
    case dynamicQuizCounterLabel
    case negativeButton
    case positiveButton
    
    case alert
    case alertTitle
    case alertMessage
    case alertOKButton
    
    var identifier: String {
        switch self {
        case .staticQuestionLabel:
            "static question label"
        case .dynamicQuestionLabel:
            "dynamic question label"
        case .dynamicFilmCoverView:
            "dynamic film cover"
        case .dynamicQuizCounterLabel:
            "counter"
        case .negativeButton:
            "No"
        case .positiveButton:
            "Yes"
        case .alert:
            "game over alert"
        case .alertTitle:
            "alert title label"
        case .alertMessage:
            "alert message label"
        case .alertOKButton:
            "allert action button"
        @unknown default:
            "not implemented"
        }
    }
    
    var label: String {
        switch self {
        case .staticQuestionLabel:
            ""
        case .dynamicQuestionLabel:
            ""
        case .dynamicFilmCoverView:
            ""
        case .dynamicQuizCounterLabel:
            ""
        case .negativeButton:
            "Negative button"
        case .positiveButton:
            "Positive button"
        case .alert:
            ""
        case .alertTitle:
            ""
        case .alertMessage:
            ""
        case .alertOKButton:
            ""
        @unknown default:
            "not implemented"
        }
    }
}
