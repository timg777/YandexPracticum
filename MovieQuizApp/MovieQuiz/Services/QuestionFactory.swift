import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    private let availableQuestions: [QuizQuestionModel] = [
        .init(
            image: .theGodfather,
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            image: .theDarkKnight,
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            image: .killBill,
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            image: .theAvengers,
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            image: .deadpool,
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            image: .theGreenKnight,
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            image: .old,
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        .init(
            image: .theIceAgeAdventuresOfBuckWild,
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        .init(
            image: .tesla,
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        .init(
            image: .vivarium,
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
    ]
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func requestQuestion(_ index: Int) {
        delegate?.didReceiveNextQuestion(availableQuestions[safe: index])
    }
}
