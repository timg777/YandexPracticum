protocol StatisticServiceDelegate: AnyObject {
    func statisticServiceDidUpdate(results: [GameResult])
    func statisticServiceDidUpdate(gameState: GameState)
}
