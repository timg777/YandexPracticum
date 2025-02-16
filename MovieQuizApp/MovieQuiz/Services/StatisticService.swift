import Foundation


final class StatisticService: StaticticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    weak var delegate: StatisticServiceDelegate?
    
    private(set) var results: [GameResult] {
        didSet {
            delegate?.statisticServiceDidUpdate(results: results)
        }
    }
    private(set) var gameState: GameState {
        didSet {
            delegate?.statisticServiceDidUpdate(gameState: gameState)
        }
    }
    
    init(gameState: GameState, results: [GameResult], delegate: StatisticServiceDelegate?) {
        self.gameState = gameState
        self.results = results
        self.delegate = delegate
    }
    
}



// MARK: - storing game stats
private extension StatisticService {
    func store(result: GameResult) {
        results.append(result)
    }
}
extension StatisticService {
    func set(gameState: GameState) {
        self.gameState = gameState
    }
    func set(results: [GameResult]) {
        self.results = results
    }
}


// MARK: - changing game state
extension StatisticService {
    func incCurrentIndex() {
        gameState.currentIndex += 1
    }
    
    func incCurrentCorrectAnswers() {
        gameState.correctAnswers += 1
    }
    
    func resetLoadNewState(totalQuestions: Int) {
        gameState = .init(totalQuestions: totalQuestions)
    }
    
    func backUpCurrentGame(dateString: String) {
        store(result: GameResult(correctAnswers: gameState.correctAnswers, totalQuestions: gameState.totalQuestions, date: dateString))
    }
}
