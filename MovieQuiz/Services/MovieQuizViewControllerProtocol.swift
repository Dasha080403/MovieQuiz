//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Дарья Савинкина on 22.10.2025.
//


import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}

