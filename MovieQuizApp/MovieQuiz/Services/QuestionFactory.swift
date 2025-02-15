import Foundation


final class QuestionFactory: QuestionFactoryProtocol {
    
    private(set) var availableQuestions: [QuizQuestionModel]
    private(set) var currentQuestion: QuizQuestionModel? {
        didSet {
            guard oldValue != currentQuestion else { return }
            receiveNextQuestion(currentQuestion)
        }
    }
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(questions: [QuizQuestionModel], delegate: QuestionFactoryDelegate) {
        self.availableQuestions = questions
        self.delegate = delegate
    }
    
}

extension QuestionFactory {
    func resetGameState(newQuestions: [QuizQuestionModel]) {
        availableQuestions = newQuestions
    }
    
    func receiveNextQuestion(_ question: QuizQuestionModel?) {
        delegate?.didReceiveNextQuestion(question)
    }
    
    func requestNextQuestion(_ index: Int) {
        setUpNewQuestion(question: availableQuestions[safe: index])
    }
    
    private func setUpNewQuestion(question: QuizQuestionModel?) {
        self.currentQuestion = question
    }
    func deallocCurrentQuestion() {
        currentQuestion = nil
    }
}
