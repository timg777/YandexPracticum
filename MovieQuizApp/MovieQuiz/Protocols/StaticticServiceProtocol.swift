protocol StatisticService {
    var currentGame: GameState { get }
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameResult { get }

    func resetGameState()
    func store(totalQuestions amount: Int)
    func incCurrentQuestionIndex()
    func incCurrentCorrectAnswers()
}
