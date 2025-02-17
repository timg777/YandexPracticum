// MARK: - создал mutable структуру как тип для ведения текущей статистики
struct GameState {
    private(set) var correctAnswers: Int = 0
    private(set) var questionIndex: Int = 0
}

extension GameState {
    mutating func incCorrectAnswers() {
        correctAnswers += 1
    }
    mutating func incCurrentQuestionIndex() {
        questionIndex += 1
    }
    mutating func reset() {
        correctAnswers = 0
        questionIndex = 0
    }
}
