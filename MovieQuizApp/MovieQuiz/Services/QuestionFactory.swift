import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    // MARK: - Internal Proprties
    weak var delegate: QuestionFactoryDelegate?
    
    var movies: [MostPopularMovie]? {
        didSet {
            convertFilmsToQuizQuestions()
            updateQuestionsPool()
        }
    }
    
    // MARK: - Private Properties
    private var availableQuestions: [QuizQuestionModel] = []
    private var currentQuestionsPool: [QuizQuestionModel] = []
    private var currentQuestionsPoolPointer: Int = 0
    
    // MARK: - Initializer
    init(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }
}

// MARK: - Extension + Internal Methods
extension QuestionFactory {
    func requestQuestion(_ index: Int) {
        delegate?.didReceiveNextQuestion(currentQuestionsPool[safe: index])
    }
    
    func updateQuestionsPool() {
        let questionsAmount = Int(GlobalConfig.questionsAmount.rawValue)
        let totalQuestionsAmount = Int(GlobalConfig.totalQuestionsAmount.rawValue)
        currentQuestionsPoolPointer += 1
        
        if currentQuestionsPoolPointer == totalQuestionsAmount / questionsAmount {
            setQuestionPool(byNewBound: false)
        } else {
            setQuestionPool(byNewBound: true)
        }
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
    
    func convert(model: MostPopularMovie) -> QuizQuestionModel {
        let randomQuestionDetails = self.randomQuestionDetails(by: model.rating)
        return .init(
            imageURL: model.imageURL,
            question: randomQuestionDetails.question,
            correctAnswer: randomQuestionDetails.correctAnswer
        )
    }
}

// MARK: - Extensions + Private Methods
private extension QuestionFactory {
    func setQuestionPool(byNewBound: Bool) {
        let questionsAmount = Int(GlobalConfig.questionsAmount.rawValue)
        var lowerBound: Int
        var upperBound: Int
        
        if byNewBound {
            let bound = currentQuestionsPoolPointer * questionsAmount
            lowerBound = bound
            upperBound = bound + questionsAmount
        } else {
            currentQuestionsPoolPointer = 0
            lowerBound = 0
            upperBound = questionsAmount
        }
        
        if let questions = availableQuestions[safe: lowerBound..<upperBound] {
            currentQuestionsPool = questions.shuffled()
        } else {
            delegate?.didReceiveNextQuestion(nil)
        }
    }
    
    func convertFilmsToQuizQuestions() {
        movies?.forEach {
            let question = convert(model: $0)
            availableQuestions.append(question)
        }
    }
}
