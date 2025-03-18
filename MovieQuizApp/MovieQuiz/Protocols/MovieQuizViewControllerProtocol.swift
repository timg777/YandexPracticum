import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func updateFilmCoverView(uiimage: UIImage?)
    func updateDynamicQuestionLabel(_ labelText: String)
    func updateCounterLabel(_ labelText: String)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func hideFilmCoverBorder()
    
    func setBorderColorForDynamicFilmCoverView( isCorrectAnswer: Bool )
    func setLoadingImageState(isLoaded: Bool)
    
    func switchButtonsAvailableState()
    
    @MainActor
    func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)?
    )
}
