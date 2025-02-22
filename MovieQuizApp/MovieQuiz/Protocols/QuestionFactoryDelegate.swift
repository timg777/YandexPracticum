protocol QuestionFactoryDelegate: AnyObject {
    func didFailConvertURLToImageData(with error: MovieQuizError)
    func didReceiveNextQuestion(_ question: QuizQuestionModel?)
}
