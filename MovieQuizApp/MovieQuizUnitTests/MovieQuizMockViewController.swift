@testable import MovieQuiz
import UIKit

final class MovieQuizMockViewController: MovieQuizViewControllerProtocol {
    var isUserInteractionEnabledForButtons: Bool = true
    var filmCoverViewImage: UIImage?
    var questionLabelText = ""
    var counterLabelText = ""
    var loadingImageStateIsHidden = true
    var loadingIndicatorIsHidden = true
    var filmCoverBorderIsHidden = true
    var filmCoverBorderWidth: CGFloat = 0
    var filmCoverBorderColor: CGColor?
    
    var actionCallBack: (() -> Void)?
    
    func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)?
    ) {
        completion?()
        actionCallBack?()
    }
    
    func updateFilmCoverView(uiimage: UIImage?) {
        filmCoverViewImage = uiimage
        actionCallBack?()
    }
    
    func updateDynamicQuestionLabel(_ labelText: String) {
        questionLabelText = labelText
        actionCallBack?()
    }
    
    func updateCounterLabel(_ labelText: String) {
        counterLabelText = labelText
        actionCallBack?()
    }
    
    func showLoadingIndicator() {
        loadingIndicatorIsHidden = false
        actionCallBack?()
    }
    
    func hideLoadingIndicator() {
        loadingIndicatorIsHidden = true
        actionCallBack?()
    }
    
    func hideFilmCoverBorder() {
        filmCoverBorderIsHidden = true
        filmCoverBorderWidth = 0
        actionCallBack?()
    }
    
    func setBorderColorForDynamicFilmCoverView(isCorrectAnswer: Bool) {
        filmCoverBorderColor = UIColor.filmCoverBorderColor(isCorrectAnswer: isCorrectAnswer)
        filmCoverBorderWidth = GlobalConfig.filmCoverBorderViewWidth.rawValue
        actionCallBack?()
    }
    
    func setLoadingImageState(isLoaded: Bool) {
        loadingImageStateIsHidden = !isLoaded
        actionCallBack?()
    }
    
    func switchButtonsAvailableState() {
        isUserInteractionEnabledForButtons.toggle()
        actionCallBack?()
    }
}
