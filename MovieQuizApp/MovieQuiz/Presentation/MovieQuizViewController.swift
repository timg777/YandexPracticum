import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outles
    @IBOutlet private weak var staticQuestionLabel: UILabel!
    @IBOutlet private weak var dynamicQuizCounterLabel: UILabel!
    @IBOutlet private weak var dynamicFilmCoverView: UIImageView!
    @IBOutlet private weak var dynamicQuestionLabel: UILabel!
    @IBOutlet private weak var negativeButton: UIButton!
    @IBOutlet private weak var positiveButton: UIButton!
    
    // MARK: - private variables
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestionModel?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
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
        
        questionFactory?.requestQuestion(statisticService?.currentGame.questionIndex ?? 0)
        statisticService?.checkForEndedGameAfterGameReopen(presentAlert: presentAlert)
    }
}

// MARK: - conforming by delegate
extension MovieQuizViewController: QuestionFactoryDelegate, AlertPresenterDelegate {
    
    func didReceiveNextQuestion(_ question: QuizQuestionModel?) {
        currentQuestion = question
        guard let question = question else {
            statisticService?.store(totalQuestions: questionsAmount)
            presentAlert(kind: .report)
            return
        }
        updateUI(question: question)
    }
    
    func didTappedAlertButton() {
        statisticService?.resetGameState()
        questionFactory?.requestQuestion(0)
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
            nil)
    }
    
    func switchButtonsAvailableState() {
        self.negativeButton.isUserInteractionEnabled.toggle()
        self.positiveButton.isUserInteractionEnabled.toggle()
    }
    
}

// MARK: - ui managing
private extension MovieQuizViewController {
    
    func updateUI(question: QuizQuestionModel) {
        UIView.animate( withDuration: 1 ) { [weak self] in
            guard let self else { return }
            dynamicQuestionLabel.text = question.question
            dynamicQuizCounterLabel.text = "\((statisticService?.currentGame.questionIndex ?? 0) + 1)/10"
        }
        
        UIView.transition(
            with: self.dynamicFilmCoverView,
            duration: 0.3,
            options: .transitionCrossDissolve
        ){ [weak self] in
            self?.dynamicFilmCoverView.image = question.image
        }
    }
}

// MARK: - initialization
private extension MovieQuizViewController {
    
    func initialViewsSetUp() {
        dynamicFilmCoverView.layer.masksToBounds = true
        dynamicFilmCoverView.layer.borderWidth = GlobalConfig.dynamicFilmCoverViewLayerBorderWidth.rawValue
        dynamicFilmCoverView.layer.borderColor = UIColor.clear.cgColor
        dynamicFilmCoverView.layer.cornerRadius = GlobalConfig.cornerRadius.rawValue
        
        negativeButton.layer.cornerRadius = GlobalConfig.cornerRadius.rawValue
        positiveButton.layer.cornerRadius = GlobalConfig.cornerRadius.rawValue
    }
    
    func initialLabelsSetUp() {
        staticQuestionLabel.text = "Вопрос:"
        dynamicQuizCounterLabel.text = "?/10"
        dynamicQuestionLabel.text = "Загрузка..."
        
        negativeButton.setTitle( "Нет", for: .normal )
        positiveButton.setTitle( "Да",  for: .normal )
        
        staticQuestionLabel.textColor = .ysWhite
        dynamicQuizCounterLabel.textColor = .ysWhite
        dynamicQuestionLabel.textColor = .ysWhite
    }
    
}
