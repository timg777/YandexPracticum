

protocol QuestionFactoryProtocol: AnyObject {
    var availableQuestions: [QuizQuestionModel] { get }
    var currentQuestion: QuizQuestionModel? { get }
    func requestNextQuestion(_ index: Int)
    func resetGameState(newQuestions: [QuizQuestionModel])
    func deallocCurrentQuestion()
}
