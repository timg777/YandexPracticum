import UIKit

struct QuizQuestionModel {
    let imageURL: URL
    let question: String
    let correctAnswer: Bool
    
    var betterQualityImageURL: URL {
        URL(string: imageURL.absoluteString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg") ?? imageURL
    }
}
