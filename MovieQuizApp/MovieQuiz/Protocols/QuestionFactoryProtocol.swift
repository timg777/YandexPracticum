protocol QuestionFactoryProtocol: AnyObject {
    var movies: [MostPopularMovie]? { get set }
    func requestQuestion(_ index: Int)
    func updateQuestionsPool()
    func convert(model: MostPopularMovie) -> QuizQuestionModel
}
