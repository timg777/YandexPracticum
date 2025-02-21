import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outles
    @IBOutlet private weak var staticQuestionLabel: UILabel!
    @IBOutlet private weak var dynamicQuizCounterLabel: UILabel!
    @IBOutlet private weak var dynamicFilmCoverView: UIImageView!
    @IBOutlet private weak var dynamicQuestionLabel: UILabel!
    @IBOutlet private weak var negativeButton: UIButton!
    @IBOutlet private weak var positiveButton: UIButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - private variables
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var movieDataManager: MovieQuizDataManager?
    private let questionsAmount: Int = 250
    private var currentQuestion: QuizQuestionModel?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        tryLoadMovies()
    }
    
}

// MARK: - inital setup
private extension MovieQuizViewController {
    func initialSetUp() {
        initialLabelsSetUp()
        initialViewsSetUp()
        
        alertPresenter = AlertPresenter(delegate: self)
        questionFactory = QuestionFactory(delegate: self)
        statisticService = StatisticServiceImplementation()
        movieDataManager = MovieQuizDataManagerImplementation(
            loader: NWService(),
            parser: MovieQuizModelParser(),
            delegate: self
        )
    }
    func tryLoadMovies() {
        showLoadingIndicator()
        movieDataManager?.loadMovies()
    }
}

// MARK: - conforming by QuestionFactoryDelegate delegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didFailConvertURLToImageData(with error: MovieQuizError) {
        anErrorOccuredScenario(localizedDescription: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(_ question: QuizQuestionModel?) {
        currentQuestion = question
        guard let question = question else {
            statisticService?.store(totalQuestions: questionsAmount)
            presentAlert(kind: .report)
            return
        }
        setLoadingImageState()
        showLoadingIndicator()
        movieDataManager?.loadImage(url: question.betterQualityImageURL)
    }
}

// MARK: - conforming by AlertPresenterDelegate delegate
extension MovieQuizViewController: AlertPresenterDelegate {
    func didTappedAlertResetButton() {
        statisticService?.resetGameState()
        questionFactory?.requestQuestion(0)
    }
    func didTappedAlertRetryButton() {
        tryLoadMovies()
    }
}

// MARK: - conforming by MovieQuizDataManagerDelegate delegate
extension MovieQuizViewController: MovieQuizDataManagerDelegate {
    
    func didReceiveImageData(_ imageData: Data) {
        setLoadedImageState()
        hideLoadingIndicator()
        if let currentQuestion {
            updateUI(question: currentQuestion, uiimage: UIImage(data: imageData))
        }
    }
    
    func didReceiveError(_ error: Error) {
        anErrorOccuredScenario(localizedDescription: error.localizedDescription)
    }
    
    func didReceiveMovies(_ movies: [MostPopularMovie]) {
        hideLoadingIndicator()
        questionFactory?.movies = movies
        questionFactory?.requestQuestion(statisticService?.currentGame.questionIndex ?? 0)
        statisticService?.checkForEndedGameAfterGameReopen(presentAlert: presentAlert)
    }
}

// MARK: - buttons handlers
private extension MovieQuizViewController {
    
    // MARK: - IB positive button action
    @IBAction func positiveButtonTapped() {
        guard let currentQuestion = currentQuestion else { return }
        handleButtonTapped(
            currentQuestion.correctAnswer
        )
    }
    // MARK: - IB negative button action
    @IBAction func negativeButtonTapped() {
        guard let currentQuestion = currentQuestion else { return }
        handleButtonTapped(
            !currentQuestion.correctAnswer
        )
    }
    
    // MARK: - any button action handler
    func handleButtonTapped( _ isCorrectAnswer: Bool ) {
        
        statisticService?.incCurrentQuestionIndex()
        isCorrectAnswer ? statisticService?.incCurrentCorrectAnswers() : nil
        
        UIView.animate( withDuration: 0.3 ) { [weak self] in
            self?.dynamicFilmCoverView.layer.borderColor = isCorrectAnswer ? UIColor.ysGreen.cgColor : UIColor.ysRed.cgColor
            self?.dynamicFilmCoverView.layer.borderWidth = 8
        }
        
        switchButtonsAvailableState()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, qos: .userInteractive) { [weak self] in
            guard let self else { return }
            UIView.animate( withDuration: 0.3 ) { [weak self] in
                self?.dynamicFilmCoverView.layer.borderWidth = 0
            }
            switchButtonsAvailableState()
            questionFactory?.requestQuestion(statisticService?.currentGame.questionIndex ?? 0)
        }
    }
}

// MARK: - helpers
private extension MovieQuizViewController {
    
    func presentAlert(kind: AlertKind) {
        guard let statisticService else { return }
        alertPresenter?.present(
            currentGame: statisticService.currentGame,
            bestGame: statisticService.bestGame,
            gamesCount: statisticService.gamesCount,
            accuracy: statisticService.totalAccuracy,
            kind: kind,
            present: present,
            nil
        )
    }
    
    func switchButtonsAvailableState() {
        self.negativeButton.isUserInteractionEnabled.toggle()
        self.positiveButton.isUserInteractionEnabled.toggle()
    }
    
}

// MARK: - ui managing
private extension MovieQuizViewController {
    
    func updateUI(question: QuizQuestionModel, uiimage: UIImage?) {
        UIView.animate( withDuration: 1 ) { [weak self] in
            guard let self else { return }
            dynamicQuestionLabel.text = question.question
            dynamicQuizCounterLabel.text = "\((statisticService?.currentGame.questionIndex ?? 0) + 1)/\(questionsAmount)"
        }
        
        UIView.transition(
            with: dynamicFilmCoverView,
            duration: 0.3,
            options: .transitionCrossDissolve
        ){ [weak self] in
            self?.dynamicFilmCoverView.image = uiimage
        }
    }
    
    func anErrorOccuredScenario(localizedDescription: String) {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        presentAlert(kind: .error(localizedDescription))
    }
    
    func showLoadingIndicator() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    
    func setLoadingImageState() {
        UIView.transition(
            with: dynamicFilmCoverView,
            duration: 0.15) { [weak self] in
                self?.dynamicFilmCoverView.layer.opacity = 0.3
            }
    }
    
    func setLoadedImageState() {
        UIView.transition(
            with: dynamicFilmCoverView,
            duration: 0.5) { [weak self] in
                self?.dynamicFilmCoverView.layer.opacity = 1
            }
    }
}

// MARK: - initialization
private extension MovieQuizViewController {
    
    func initialViewsSetUp() {
        dynamicFilmCoverView.layer.masksToBounds = true
        dynamicFilmCoverView.layer.borderWidth = GlobalConfig.dynamicFilmCoverViewLayerBorderWidth.rawValue
        dynamicFilmCoverView.layer.borderColor = UIColor.clear.cgColor
        dynamicFilmCoverView.layer.cornerRadius = GlobalConfig.posterCornerRadius.rawValue
        
        negativeButton.layer.cornerRadius = GlobalConfig.buttonsCornerRadius.rawValue
        positiveButton.layer.cornerRadius = GlobalConfig.buttonsCornerRadius.rawValue
        
        loadingIndicator.hidesWhenStopped = true
    }
    
    func initialLabelsSetUp() {
        staticQuestionLabel.text = "Вопрос:"
        dynamicQuizCounterLabel.text = "?/\(questionsAmount)"
        dynamicQuestionLabel.text = "Загрузка..."
        
        negativeButton.setTitle("Нет", for: .normal)
        positiveButton.setTitle("Да",  for: .normal)
        
        staticQuestionLabel.textColor = .ysWhite
        dynamicQuizCounterLabel.textColor = .ysWhite
        dynamicQuestionLabel.textColor = .ysWhite
    }
    
}
