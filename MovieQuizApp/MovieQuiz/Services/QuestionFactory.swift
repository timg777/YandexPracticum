import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    var movies: [MostPopularMovie]? {
        didSet {
            convertFilmsToQuizQuestions()
        }
    }
    
    private var availableQuestions: [QuizQuestionModel] = []
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func requestQuestion(_ index: Int) {
        delegate?.didReceiveNextQuestion(availableQuestions[safe: index])
    }
    
    func randomQuestionDetails(by rating: String) -> (question: String, correctAnswer: Bool) {
        let comparisonGrade = ["больше", "меньше"].randomElement() ?? "больше"
        let comparisonValue = Int.random(in: 7...9)
        let question = "Рейтинг этого фильма \(comparisonGrade) чем \(comparisonValue)?"
        
        let rating = Double(rating) ?? 0.0
        
        var correctAnswer: Bool
        if comparisonGrade == "больше" {
            correctAnswer = rating >= Double(comparisonValue)
        } else {
            correctAnswer = rating <= Double(comparisonValue)
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
