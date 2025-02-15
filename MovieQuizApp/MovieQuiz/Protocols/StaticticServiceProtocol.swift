
protocol StaticticServiceProtocol {
    var results: [GameResult] { get }
    var gameState: GameState { get }
    
    func incCurrentIndex()
    func incCurrentCorrectAnswers()
    
    func backUpCurrentGame(dateString: String)
    
    func resetLoadNewState(totalQuestions: Int)
}
