import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Outles
    @IBOutlet private weak var staticQuestionLabel: UILabel!
    @IBOutlet private weak var dynamicQuizCounterLabel: UILabel!
    @IBOutlet private weak var dynamicFilmCoverView: UIImageView!
    @IBOutlet private weak var dynamicQuestionLabel: UILabel!
    @IBOutlet private weak var negativeButton: UIButton!
    @IBOutlet private weak var positiveButton: UIButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private var presenter: MovieQuizPresenter?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
}

// MARK: - Extensions + Private Methods (SetUp)
private extension MovieQuizViewController {
    func initialSetUp() {
        setUpAccessability()
        initialLabelsSetUp()
        initialViewsSetUp()
        presenter = MovieQuizPresenter(viewController: self)
    }
}

// MARK: - Extensions + Private Methods (IBAction)
private extension MovieQuizViewController {
    
    @IBAction func positiveButtonTapped() {
        presenter?.handleButtonTapped(true)
    }
    @IBAction func negativeButtonTapped() {
        presenter?.handleButtonTapped(false)
    }
    
}

// MARK: - Extensions + Internal UI Updates
extension MovieQuizViewController {
    
    func updateFilmCoverView(uiimage: UIImage?) {
        UIView.transition(
            with: dynamicFilmCoverView,
            duration: GlobalConfig.contentChangingAnimationTime.rawValue,
            options: .transitionCrossDissolve
        ) { [weak self] in
            self?.dynamicFilmCoverView.image = uiimage
        }
    }
    
    func updateDynamicQuestionLabel(_ labelText: String) {
        dynamicQuestionLabel.text = labelText
    }
    
    func updateCounterLabel(_ labelText: String) {
        dynamicQuizCounterLabel.text = labelText
    }
    
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    func hideFilmCoverBorder() {
        dynamicFilmCoverView.layer.borderColor = nil
        dynamicFilmCoverView.layer.borderWidth = 0
    }
    
    func setBorderColorForDynamicFilmCoverView(isCorrectAnswer: Bool) {
        dynamicFilmCoverView.layer.borderColor = UIColor.filmCoverBorderColor(isCorrectAnswer: isCorrectAnswer)
        dynamicFilmCoverView.layer.borderWidth = GlobalConfig.filmCoverBorderViewWidth.rawValue
    }
    
    func setLoadingImageState(isLoaded: Bool) {
        UIView.transition(
            with: dynamicFilmCoverView,
            duration: GlobalConfig.borderAnimationTime(picIsLoaded: isLoaded)) { [weak self] in
                self?.dynamicFilmCoverView.layer.opacity = GlobalConfig.filmCoverViewLayerOpacity(picIsLoaded: isLoaded)
            }
    }
    
    func switchButtonsAvailableState() {
        self.negativeButton.isUserInteractionEnabled.toggle()
        self.positiveButton.isUserInteractionEnabled.toggle()
    }
}

// MARK: - Extensions + Private Methods (Initial View SetUp)
private extension MovieQuizViewController {
    
    func initialViewsSetUp() {
        dynamicFilmCoverView.layer.masksToBounds = true
        dynamicFilmCoverView.layer.borderWidth = GlobalConfig.filmCoverViewLayerBorderWidth.rawValue
        dynamicFilmCoverView.layer.borderColor = UIColor.clear.cgColor
        dynamicFilmCoverView.layer.cornerRadius = GlobalConfig.posterCornerRadius.rawValue
        
        negativeButton.layer.cornerRadius = GlobalConfig.buttonsCornerRadius.rawValue
        positiveButton.layer.cornerRadius = GlobalConfig.buttonsCornerRadius.rawValue
        
        loadingIndicator.hidesWhenStopped = true
    }
    
    func initialLabelsSetUp() {
        staticQuestionLabel.text = "Вопрос:"
        dynamicQuizCounterLabel.text = "?/\(Int(GlobalConfig.questionsAmount.rawValue))"
        dynamicQuestionLabel.text = "Загрузка..."
        
        negativeButton.setTitle("Нет", for: .normal)
        positiveButton.setTitle("Да", for: .normal)
        
        staticQuestionLabel.textColor = .ysWhite
        dynamicQuizCounterLabel.textColor = .ysWhite
        dynamicQuestionLabel.textColor = .ysWhite
    }
    
    func setUpAccessability() {
        staticQuestionLabel.accessibilityIdentifier = AccessibilityElement.staticQuestionLabel.identifier

        dynamicQuestionLabel.accessibilityIdentifier = AccessibilityElement.dynamicQuestionLabel.identifier
        dynamicFilmCoverView.accessibilityIdentifier = AccessibilityElement.dynamicFilmCoverView.identifier
        dynamicQuizCounterLabel.accessibilityIdentifier = AccessibilityElement.dynamicQuizCounterLabel.identifier
        
        negativeButton.accessibilityIdentifier = AccessibilityElement.negativeButton.identifier
        negativeButton.accessibilityLabel = AccessibilityElement.negativeButton.label
        
        positiveButton.accessibilityIdentifier = AccessibilityElement.positiveButton.identifier
        positiveButton.accessibilityLabel = AccessibilityElement.positiveButton.label
    }
    
}
