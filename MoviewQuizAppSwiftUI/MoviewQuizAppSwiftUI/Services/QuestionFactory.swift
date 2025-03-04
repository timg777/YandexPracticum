import SwiftUI
import Combine

final class QuestionFactory: ObservableObject {
    
    private let availableQuestions: [QuizQuestionModel] = [
        .init(
            imageString: "The Godfather",
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageString: "The Dark Knight",
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageString: "Kill Bill",
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageString: "The Avengers",
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageString: "Deadpool",
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageString: "The Green Knight",
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        .init(
            imageString: "Old",
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        .init(
            imageString: "The Ice Age Adventures of Buck Wild",
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        .init(
            imageString: "Tesla",
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        .init(
            imageString: "Vivarium",
            question: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
    ]
    
    private var canclellables = Set<AnyCancellable>()
    
    @Published var currentQuestion: QuizQuestionModel?
    
    init() {
        $currentQuestion
            .receive(on: RunLoop.main)
            .assign(to: \.currentQuestion, on: self)
            .store(in: &canclellables)
    }
    
    func requestQuestion(_ index: Int) {
        currentQuestion = availableQuestions[safe: index]
    }
}
