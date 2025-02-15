//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Superior Warden on 07.02.2025.
//


protocol QuestionFactoryDelegate: AnyObject {
    
    func didReceiveNextQuestion(_ question: QuizQuestionModel?)

}
