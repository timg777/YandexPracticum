import UIKit

// MARK: - Presenter
final class MovieQuizPresenter: MovieQuizPresenterProtocol {
    
    // MARK: - Private Properties
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var moviesDataManager: DataRouting?
    private var currentQuestion: QuizQuestionModel?
    
    // MARK: - Internal Initializer
    init(
        viewController: MovieQuizViewControllerProtocol,
        networkService: NWServiceProtocol? = nil
    ) {
        self.viewController = viewController
        
        alertPresenter = AlertPresenter()
        questionFactory = QuestionFactory(delegate: self)
        statisticService = StatisticServiceImplementation()
        moviesDataManager = DataManager(
            loader: networkService ?? NWService(),
            parser: ModelParser(),
            delegate: self
        )
        
        tryLoadMovies()
    }
}

// MARK: - Extensions + Internal Helpers (Buttons Handlers)
extension MovieQuizPresenter {
    
    func handleButtonTapped(_ isPositiveButton: Bool) {
        
        let isCorrectAnswer = currentQuestion?.correctAnswer == isPositiveButton
        
        statisticService?.incCurrentQuestionIndex()
        isCorrectAnswer ? statisticService?.incCurrentCorrectAnswers() : nil
        
        UIView.animate(withDuration: GlobalConfig.contentChangingAnimationTime.rawValue) { [weak self] in
            self?.viewController?.setBorderColorForDynamicFilmCoverView(isCorrectAnswer: isCorrectAnswer)
        }
        
        viewController?.switchButtonsAvailableState()
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + GlobalConfig.waitTimeForButtonsUnlock.rawValue,
            qos: .userInteractive
        ) { [weak self] in
            guard let self else { return }
            UIView.animate(withDuration: GlobalConfig.contentChangingAnimationTime.rawValue) { [weak self] in
                self?.viewController?.hideFilmCoverBorder()
            }
            viewController?.switchButtonsAvailableState()
            questionFactory?.requestQuestion(statisticService?.currentGame.questionIndex ?? 0)
        }
    }
}

// MARK: - Extensions + Internal Helpers (other)
extension MovieQuizPresenter {
    @MainActor
    @preconcurrency
    func presentAlert(kind: AlertKind) {
        if let statisticService,
            let viewController,
            let questionFactory {
            alertPresenter?.present(
                currentGame: statisticService.currentGame,
                bestGame: statisticService.bestGame,
                gamesCount: statisticService.gamesCount,
                accuracy: statisticService.totalAccuracy,
                kind: kind,
                present: viewController.present,
                { [weak self] in
                    guard let self else { return }
                    switch kind {
                    case .report:
                        statisticService.resetGameState()
                        questionFactory.updateQuestionsPool()
                        questionFactory.requestQuestion(0)
                    case .error(_):
                        tryLoadMovies()
                    }
                }
            )
        }
    }
    
    func anErrorOccuredScenario(localizedDescription: String) {
        viewController?.showLoadingIndicator()
        presentAlert(kind: .error(localizedDescription))
    }
}

// MARK: - Extensions + Conforming to QuestionFactoryDelegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didFailConvertURLToImageData(with error: MovieQuizError) {
        anErrorOccuredScenario(localizedDescription: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(_ question: QuizQuestionModel?) {
        currentQuestion = question
        guard let question else {

            storeAndPresentAlertOnGameEnded()
            return
        }
        viewController?.setLoadingImageState(isLoaded: false)
        viewController?.showLoadingIndicator()
        moviesDataManager?.loadImage(url: question.betterQualityImageURL)
    }
}


// MARK: - Extensions + Conforming to MovieQuizDataManagerDelegate
extension MovieQuizPresenter: DataManagerDelegate {
    
    func didReceiveImageData(_ imageData: Data) {
        viewController?.setLoadingImageState(isLoaded: true)
        viewController?.hideLoadingIndicator()
        if let currentQuestion {
            UIView.animate(withDuration: 1) { [weak self] in
                guard let self else { return }
                viewController?.updateDynamicQuestionLabel(currentQuestion.question)
                let currentIndex = (statisticService?.currentGame.questionIndex ?? 0) + 1
                viewController?.updateCounterLabel("\(currentIndex)/\(Int(GlobalConfig.questionsAmount.rawValue))")
            }
            viewController?.updateFilmCoverView(uiimage: UIImage(data: imageData))
        }
    }
    
    func didReceiveError(_ error: MovieQuizError) {
        anErrorOccuredScenario(localizedDescription: error.localizedDescription)
    }
    
    func didReceiveMovies(_ movies: [MostPopularMovie]) {
        viewController?.hideLoadingIndicator()
        questionFactory?.movies = movies
        questionFactory?.requestQuestion(statisticService?.currentGame.questionIndex ?? 0)
        statisticService?.checkForEndedGameAfterGameReopen(presentAlert: presentAlert)
    }
}

// MARK: - Extensions + Private Methods
private extension MovieQuizPresenter {
    func storeAndPresentAlertOnGameEnded() {
        statisticService?.store(totalQuestions: Int(GlobalConfig.questionsAmount.rawValue))
        presentAlert(kind: .report)
    }
    
    func tryLoadMovies() {
        viewController?.showLoadingIndicator()
        moviesDataManager?.loadMovies()
    }
}
