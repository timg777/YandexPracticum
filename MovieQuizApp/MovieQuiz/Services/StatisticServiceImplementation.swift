import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case currentCorrectAnswers
        case currentQuestionIndex
        case total
        case correctAnswersSum
        case gamesCount
        case bestGameDate
        case bestGameScore
    }
    
    private let storage: UserDefaults = .standard
    
    var totalAccuracy: Double {
        let correctAnswersSum = storage.integer(forKey: Keys.correctAnswersSum.rawValue)
        return Double(correctAnswersSum) / Double(gamesCount) * 10
    }
    
    private(set) var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private(set) var bestGame: GameResult {
        get {
            .init(
                correctAnswers: storage.integer(forKey: Keys.bestGameScore.rawValue),
                totalQuestions: storage.integer(forKey: Keys.total.rawValue),
                date: storage.string(forKey: Keys.bestGameDate.rawValue) ?? ""
            )
        }
        set {
            storage.set(newValue.correctAnswers, forKey: Keys.bestGameScore.rawValue)
            storage.set(newValue.totalQuestions, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    private(set) var currentGame: GameState {
        get {
            .init(
                correctAnswers: storage.integer(forKey: Keys.currentCorrectAnswers.rawValue),
                questionIndex: storage.integer(forKey: Keys.currentQuestionIndex.rawValue)
            )
        }
        set {
            storage.set(newValue.questionIndex, forKey: Keys.currentQuestionIndex.rawValue)
            storage.set(newValue.correctAnswers, forKey: Keys.currentCorrectAnswers.rawValue)
        }
    }
    
}

extension StatisticServiceImplementation {
    
    func checkForEndedGameAfterGameReopen(presentAlert: @escaping (AlertKind) -> Void) {
        if currentGame.questionIndex == 10 {
            DispatchQueue.main.async(qos: .userInteractive) {
                presentAlert(.report)
            }
        }
    }
    
    func resetGameState() {
        currentGame.reset()
    }
    
    func store(totalQuestions amount: Int) {
        gamesCount += 1
        
        let correctAnswersSum = storage.integer(forKey: Keys.correctAnswersSum.rawValue) + currentGame.correctAnswers
        storage.set(correctAnswersSum, forKey: Keys.correctAnswersSum.rawValue)
        
        if currentGame.correctAnswers > bestGame.correctAnswers {
            bestGame = .init(correctAnswers: currentGame.correctAnswers, totalQuestions: amount, date: Date().dateTimeString)
        }
    }
    
    func incCurrentQuestionIndex() {
        currentGame.incCurrentQuestionIndex()
    }
    
    func incCurrentCorrectAnswers() {
        currentGame.incCorrectAnswers()
    }
    
}
