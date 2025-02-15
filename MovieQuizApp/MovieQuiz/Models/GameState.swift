
struct GameState {
    let totalQuestions: Int
    var currentIndex: Int
    var correctAnswers: Int
    
    init(totalQuestions: Int = 0, currentIndex: Int = 0, correctAnswers: Int = 0) {
        self.totalQuestions = totalQuestions
        self.currentIndex = currentIndex
        self.correctAnswers = correctAnswers
    }
}

extension GameState: Storable {}
