


protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(_ question: QuizQuestionModel?)
    func didLoadDataFromServer()
    func didFailToLoadDataFromServer(with error: Error)
}
