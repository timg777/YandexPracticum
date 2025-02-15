import UIKit




final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var staticQuestionLabel: UILabel!
    
    @IBOutlet private weak var dynamicQuizCounterLabel: UILabel!
    @IBOutlet private weak var dynamicFilmCoverView: UIImageView!
    @IBOutlet private weak var dynamicQuestionLabel: UILabel!
    
    @IBOutlet private weak var negativeButton: UIButton!
    @IBOutlet private weak var positiveButton: UIButton!
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statistics: StatisticService?
    private var storageManager: StorageManagerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
    }
    
}




// MARK: - работа с такими данным через UserDefualts плохая идея, надеюсь, что в дальнейшем можно будет синхронизировать состояние приложения в бд, чтобы не хранить mock данные, а подгружать по мере необходиомсти






// MARK: - inital setup
private extension MovieQuizViewController {
    func initialSetUp() {
        
        self.initialLabelsSetUp()
        self.initialViewsSetUp()
        
        // MARK: - for ex: get data and react
        //        let result = NWService.shared.fetch( method: .GET, module: .films )
        //        switch result {
        //        case .success(let success):
        //            <#code#>
        //        case .failure(let failure):
        //            <#code#>
        //        }
        let fetchedQuestions = tryFetchNewData()
        
        self.storageManager = StorageManager()
        self.alertPresenter = AlertPresenter(delegate: self)
        self.questionFactory = QuestionFactory(
            questions: fetchedQuestions,
            delegate: self
        )
        
        let lastGameState: GameState? = storageManager?.get(forKey: .gameState)
        let gameResults: [GameResult] = storageManager?.get(forKey: .gameResults) ?? []
    
        let initialGameState = GameState(
            totalQuestions: fetchedQuestions.count,
            currentIndex: 0,
            correctAnswers: 0
        )
        
        self.statistics = StatisticService(gameState: lastGameState ?? initialGameState, results: gameResults, delegate: self)
        
        guard !self.checkForEndedGameAfterGameReopen(
            results: gameResults,
            currentQuestion: questionFactory?.currentQuestion,
            lastGameState: lastGameState
        ) else { return }
        
        if let currentIndex = statistics?.gameState.currentIndex {
            self.questionFactory?.requestNextQuestion(currentIndex)
        } else {
            self.questionFactory?.requestNextQuestion(0)
        }
        
    }
}



// MARK: - conforming by delegate
extension MovieQuizViewController: QuestionFactoryDelegate, AlertPresenterDelegate, StatisticServiceDelegate {
    
    func statisticServiceDidUpdate(results: [GameResult]) {
        storageManager?.store(key: .gameResults, value: results)
    }
    
    func statisticServiceDidUpdate(gameState: GameState) {
        storageManager?.store(key: .gameState, value: gameState)
    }
    
    
    func resetGameState() {
        let newData = tryFetchNewData()
        questionFactory?.resetGameState(newQuestions: newData)
        statistics?.resetLoadNewState(totalQuestions: newData.count)
    }
    
    
    func didReceiveNextQuestion(_ question: QuizQuestionModel?) {
        guard let question = question else {
            let datetime = Date().dateTimeString
            statistics?.backUpCurrentGame(dateString: datetime)
            questionFactory?.deallocCurrentQuestion()
            
            guard let report = buildLastGameAlertMessage() else {
                presentAlert(report: "", kind: .error)
                // TODO: - handle error
                return
            }
            presentAlert(report: report, kind: .report)
            return
        }
        updateUI(question: question)
    }
    
    func didTappedAlertButton() {
        resetGameState()
        questionFactory?.requestNextQuestion(0)
    }

}


// MARK: - buttons handlers
private extension MovieQuizViewController {
    
    @IBAction func positiveButtonTapped() {
        guard let currentQuestion = self.questionFactory?.currentQuestion else { return }
        self.handleButtonTapped(
            currentQuestion.correctAnswer
        )
    }
    
    @IBAction func negativeButtonTapped() {
        guard let currentQuestion = self.questionFactory?.currentQuestion else { return }
        self.handleButtonTapped(
            !currentQuestion.correctAnswer
        )
    }
    
    
    func handleButtonTapped( _ isCorrectAnswer: Bool ) {
        
        isCorrectAnswer ? statistics?.incCurrentCorrectAnswers() : nil
        
        UIView.animate( withDuration: 0.3 ) { [weak self] in
            guard let self else { return }
            dynamicFilmCoverView.layer.borderColor = isCorrectAnswer ? UIColor.ysGreen.cgColor : UIColor.ysRed.cgColor
            dynamicFilmCoverView.layer.borderWidth = 8
        }
        
        self.switchButtonsAvailableState()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self else { return }
            UIView.animate( withDuration: 0.3 ) { [weak self] in
                guard let self else { return }
                dynamicFilmCoverView.layer.borderWidth = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self, let statistics else { return }
            switchButtonsAvailableState()
            questionFactory?.requestNextQuestion(statistics.gameState.currentIndex + 1)
            statistics.incCurrentIndex()
        }
        
    }
    
}



// MARK: - helpers
private extension MovieQuizViewController {
    
    func checkForEndedGameAfterGameReopen(
        results: [GameResult],
        currentQuestion: QuizQuestionModel?,
        lastGameState: GameState?
    ) -> Bool {
        if currentQuestion == nil, lastGameState?.currentIndex == 10, !results.isEmpty {
            guard let report = buildLastGameAlertMessage() else { return false }
            DispatchQueue.main.async { [weak self] in
                self?.hideUI()
                self?.presentAlert(report: report, kind: .report)
            }
            return true
        }
        return false
    }
    
    func presentAlert(report: String, kind: AlertKind) {
        alertPresenter?.present(report: report, kind: kind, present: present, showUI: showUI, nil)
    }
    
    func tryFetchNewData() /*async throws*/ -> [QuizQuestionModel] {
        NWService.shared.testFetch()
    }
    
    func switchButtonsAvailableState() {
        self.negativeButton.isUserInteractionEnabled.toggle()
        self.positiveButton.isUserInteractionEnabled.toggle()
    }
    
    func buildLastGameAlertMessage() -> String? {
        
        guard let statistics else { return nil }
        guard let recordState = statistics.results.max(by: {$0.correctAnswers < $1.correctAnswers}) else {
            // TODO: - handle error
            return nil
        }
        let recordScore = recordState.correctAnswers
        let correctAnswersSum = statistics.results.reduce(0) { $0 + $1.correctAnswers }
        let accuracy = String( format: "%.2f", Double(correctAnswersSum) / Double(statistics.results.count) * 10 )
        
        let datetimeString = statistics.results.last?.date ?? "нет данных"
        
        return """
           \nВаш результат: \(statistics.results.last?.correctAnswers ?? -1)/10
            "Количество сыгранных квизов: \(statistics.results.count)
            "Рекорд: \(recordScore) (\(datetimeString))
            "Средняя точность: \(accuracy)%
        """
        
    }
    
}

// MARK: - ui managing
private extension MovieQuizViewController {
    func hideUI() {
        self.staticQuestionLabel.isHidden = true
        self.dynamicFilmCoverView.isHidden = true
        self.dynamicQuestionLabel.isHidden = true
        self.dynamicQuizCounterLabel.isHidden = true
        self.negativeButton.isHidden = true
        self.positiveButton.isHidden = true
    }
    
    func showUI() {
        self.staticQuestionLabel.isHidden = false
        self.dynamicFilmCoverView.isHidden = false
        self.dynamicQuestionLabel.isHidden = false
        self.dynamicQuizCounterLabel.isHidden = false
        self.negativeButton.isHidden = false
        self.positiveButton.isHidden = false
    }
    
    func updateUI(question: QuizQuestionModel) {
        
        UIView.animate( withDuration: 1 ) { [weak self] in
            guard let self else { return }
            dynamicQuestionLabel.text = question.question
            dynamicQuizCounterLabel.text = "\(statistics?.gameState.currentIndex ?? 0 + 1)/\(statistics?.gameState.totalQuestions ?? 0)"
        }
        
        UIView.transition(
            with: self.dynamicFilmCoverView,
            duration: 0.3,
            options: .transitionCrossDissolve
        ){ [weak self] in
            guard let self else { return }
            dynamicFilmCoverView.image = question.image
        }
    }
}


// MARK: - initialization
private extension MovieQuizViewController {
    
    func initialViewsSetUp() {
        
        self.dynamicFilmCoverView.layer.masksToBounds = true
        self.dynamicFilmCoverView.layer.borderWidth = GlobalConfig.dynamicFilmCoverViewLayerBorderWidth
        self.dynamicFilmCoverView.layer.borderColor = UIColor.clear.cgColor
        self.dynamicFilmCoverView.layer.cornerRadius = GlobalConfig.cornerRadius
        
        self.negativeButton.layer.cornerRadius = GlobalConfig.cornerRadius
        self.positiveButton.layer.cornerRadius = GlobalConfig.cornerRadius
        
    }
    
    func initialLabelsSetUp() {
        
        self.staticQuestionLabel.text = "Вопрос:"
        self.dynamicQuizCounterLabel.text = "1/10"
        self.dynamicQuestionLabel.text = "Рейтинг этого фильма меньше чем 5?"
        
        self.negativeButton.setTitle( "Нет", for: .normal )
        self.positiveButton.setTitle( "Да",  for: .normal )
        
        self.staticQuestionLabel.textColor = .ysWhite
        self.dynamicQuizCounterLabel.textColor = .ysWhite
        self.dynamicQuestionLabel.textColor = .ysWhite
        
    }
    
}


// MARK: - simple global config
struct GlobalConfig {
    static let cornerRadius: CGFloat = 15
    static let dynamicFilmCoverViewLayerBorderWidth: CGFloat = 8
}
    
    


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/



enum AlertKind {
    case report
    case error
    
    var header: String {
        switch self {
        case .report:
            return "Этот раунд окончен!"
        case .error:
            return "Ой"
        }
    }
    
    func body(report: String = "Что-то пошло не так :_(\n Пожалуйста, повторите попытку позже") -> String {
        return report
    }
    
    var buttonText: String {
        switch self {
        case .report:
            return "Сыграть еще раз"
        case .error:
            return "Повторить"
        }
    }
}
