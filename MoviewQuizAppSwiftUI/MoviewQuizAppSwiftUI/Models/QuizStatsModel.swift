import SwiftUI

struct QuizStatsModel {
    private(set) var correctAnswers: Int = 0
    private(set) var dateString: String?
}

extension QuizStatsModel {
    
    mutating func incrementCorrectAnswers() {
        self.correctAnswers += 1
    }
    
    mutating func setDate(_ dateString: String) {
        self.dateString = dateString
    }
    
}

