@testable import MovieQuiz
import XCTest

final class MovieQuizQuestionFactoryTests: XCTestCase {
    
    func testConvertModel() throws {
        // Given
        if let safeURL = URL(string: "https://google.com") {
            let mostPopularMovie = MostPopularMovie(title: "sample_movie", rating: "0", imageURL: safeURL)
            let expectedQuizQuestionModel = QuizQuestionModel(imageURL: safeURL, question: "", correctAnswer: false)
            let questionFactory = QuestionFactory(delegate: nil)
            
            // When
            let quizQuestionModel = questionFactory.convert(model: mostPopularMovie)
            
            // Then
            XCTAssertEqual(quizQuestionModel.imageURL, expectedQuizQuestionModel.imageURL)
            try validateQuestionGeneration(quizQuestionModel.question)
            
        } else {
            XCTAssertThrowsError("bad url")
        }
    }
    
    func validateQuestionGeneration(_ question: String) throws {
        for (index, word) in question.split(separator: " ").enumerated() {
            switch index {
            case 0:
                XCTAssertEqual(word, "Рейтинг", "1st word must be 'Рейтинг'")
            case 1:
                XCTAssertEqual(word, "этого", "2nd word must be 'этого'")
            case 2:
                XCTAssertEqual(word, "фильма", "3rd word must be 'фильма'")
            case 3:
                XCTAssertTrue(word == "больше" || word == "меньше", "4th word must be one of ['больше', 'меньше']")
            case 4:
                XCTAssertEqual(word, "чем", "5th word must be 'чем'")
            case 5:
                if let numberChar = word.first {
                    if let questionMark = question.last {
                        let number = try? XCTUnwrap(Int("\(numberChar)"), "must be successfully unwraped number")
                        XCTAssertNotNil(number, "number must be not nil")
                        XCTAssertEqual(questionMark, "?", "last character must be quiestion mark '?'")
                    } else {
                        XCTAssertThrowsError("no question mark has provided")
                    }
                } else {
                    XCTAssertThrowsError("no number has provided")
                }
            default:
                break
            }
        }
    }
}
