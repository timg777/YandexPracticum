import UIKit

struct QuizQuestionModel {
    let image: UIImage
    let question: String
    let correctAnswer: Bool
}

extension QuizQuestionModel: Hashable {}
