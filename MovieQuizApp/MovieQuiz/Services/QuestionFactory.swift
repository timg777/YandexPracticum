import Foundation


final class QuestionFactory: QuestionFactoryProtocol {
    
    private(set) var availableQuestions: [QuizQuestionModel]?
    private(set) var currentQuestion: QuizQuestionModel? {
        didSet {
            guard oldValue != currentQuestion else { return }
            receiveNextQuestion(currentQuestion)
        }
    }
    
    private let moviesLodaer: MoviesLoaderProtocol
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoaderProtocol, delegate: QuestionFactoryDelegate) {
        self.moviesLodaer = moviesLoader
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
        setUpNewQuestion(question: availableQuestions?[safe: index])
    }
    
    private func setUpNewQuestion(question: QuizQuestionModel?) {
        self.currentQuestion = question
    }
    func deallocCurrentQuestion() {
        currentQuestion = nil
    }
}
