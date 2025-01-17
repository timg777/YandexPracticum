import UIKit

struct QuizStatsModel {
    private(set) var currentIndex: Int = 0
    private(set) var correctAnswers: Int = 0
}

extension QuizStatsModel {
    
    mutating func incrementCorrectAnswers() {
        self.correctAnswers += 1
    }
    
    mutating func incrementCurrentIndex() {
        currentIndex += 1
    }
    
    mutating func reset() {
        currentIndex = -1
        correctAnswers = 0
    }
    
}

