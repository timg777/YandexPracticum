
struct GameResult {
    let correctAnswers: Int
    let totalQuestions: Int
    let date: String
}

extension GameResult: Storable {
    static func == (lhs: GameResult, rhs: GameResult) -> Bool {
        lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
    }
}
