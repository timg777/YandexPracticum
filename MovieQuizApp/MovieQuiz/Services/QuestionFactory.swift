import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    var movies: [MostPopularMovie]? {
        didSet {
            convertFilmsToQuizQuestions()
        }
    }
    
    private var availableQuestions: [QuizQuestionModel] = []
    
    
    
    //    private let availableQuestions: [QuizQuestionModel] = [
    //        .init(
    //            image: .theGodfather,
    //            question: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true
    //        ),
    //        .init(
    //            image: .theDarkKnight,
    //            question: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true
    //        ),
    //        .init(
    //            image: .killBill,
    //            question: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true
    //        ),
    //        .init(
    //            image: .theAvengers,
    //            question: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true
    //        ),
    //        .init(
    //            image: .deadpool,
    //            question: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true
    //        ),
    //        .init(
    //            image: .theGreenKnight,
    //            question: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true
    //        ),
    //        .init(
    //            image: .old,
    //            question: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false
    //        ),
    //        .init(
    //            image: .theIceAgeAdventuresOfBuckWild,
    //            question: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false
    //        ),
    //        .init(
    //            image: .tesla,
    //            question: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false
    //        ),
    //        .init(
    //            image: .vivarium,
    //            question: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false
    //        ),
    //    ]
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func requestQuestion(_ index: Int) {
        delegate?.didReceiveNextQuestion(availableQuestions[safe: index])
    }
    
    func randomQuestionDetails(by rating: String) -> (question: String, correctAnswer: Bool) {
        let comparisonGrade = ["больше", "меньше"].randomElement() ?? "больше"
        let comparisonValue = Int.random(in: 1...9)
        let question = "Рейтинг этого фильма \(comparisonGrade) чем \(comparisonValue)?"
        
        let rating = Int(rating) ?? 0
        var correctAnswer: Bool
        if comparisonGrade == "больше" {
            correctAnswer = rating > comparisonValue
        } else {
            correctAnswer = rating < comparisonValue
        }
        
        return (question, correctAnswer)
    }
    
    private func convertFilmsToQuizQuestions() {
        movies?.forEach {
            let randomQuestionDetails = self.randomQuestionDetails(by: $0.rating)
            availableQuestions.append(
                .init(
                    imageURL: $0.imageURL,
                    question: randomQuestionDetails.question,
                    correctAnswer: randomQuestionDetails.correctAnswer
                )
            )
        }
    }
    
}
