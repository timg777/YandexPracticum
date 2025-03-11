import UIKit

final class MovieQuizPresenter: MovieQuizPresenterProtocol {
    
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var moviesDataManager: DataRouting?
    private var currentQuestion: QuizQuestionModel?
    
    init(
        viewController: MovieQuizViewControllerProtocol,
        networkService: NWServiceProtocol? = nil
    ) {
        self.viewController = viewController
        
        alertPresenter = AlertPresenter(delegate: self)
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

// MARK: - buttons handlers
extension MovieQuizPresenter {
    
    // MARK: - any button action handler
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

// MARK: - helpers
extension MovieQuizPresenter {
    @MainActor
    @preconcurrency
    func presentAlert(kind: AlertKind) {
        guard let statisticService, let viewController else { return }
        alertPresenter?.present(
            currentGame: statisticService.currentGame,
            bestGame: statisticService.bestGame,
            gamesCount: statisticService.gamesCount,
            accuracy: statisticService.totalAccuracy,
            kind: kind,
            present: viewController.present,
            nil
        )
    }
    
    func anErrorOccuredScenario(localizedDescription: String) {
        viewController?.showLoadingIndicator()
        presentAlert(kind: .error(localizedDescription))
    }
}

// MARK: - conforming by QuestionFactoryDelegate delegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didFailConvertURLToImageData(with error: MovieQuizError) {
        anErrorOccuredScenario(localizedDescription: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(_ question: QuizQuestionModel?) {
        currentQuestion = question
        guard let question = question else {
            statisticService?.store(totalQuestions: Int(GlobalConfig.questionsAmount.rawValue))
            presentAlert(kind: .report)
            return
        }
        viewController?.setLoadingImageState(isLoaded: false)
        viewController?.showLoadingIndicator()
        moviesDataManager?.loadImage(url: question.betterQualityImageURL)
    }
    
    func tryLoadMovies() {
        viewController?.showLoadingIndicator()
        moviesDataManager?.loadMovies()
    }
}

// MARK: - conforming by AlertPresenterDelegate delegate
extension MovieQuizPresenter: AlertPresenterDelegate {
    func didTappedAlertResetButton() {
        statisticService?.resetGameState()
        questionFactory?.updateQuestionsPool()
        questionFactory?.requestQuestion(0)
    }
    func didTappedAlertRetryButton() {
        tryLoadMovies()
    }
}

// MARK: - conforming by MovieQuizDataManagerDelegate delegate
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
    
    func didReceiveError(_ error: Error) {
        anErrorOccuredScenario(localizedDescription: error.localizedDescription)
    }
    
    func didReceiveMovies(_ movies: [MostPopularMovie]) {
        viewController?.hideLoadingIndicator()
        questionFactory?.movies = movies
        questionFactory?.requestQuestion(statisticService?.currentGame.questionIndex ?? 0)
        statisticService?.checkForEndedGameAfterGameReopen(presentAlert: presentAlert)
    }
}
