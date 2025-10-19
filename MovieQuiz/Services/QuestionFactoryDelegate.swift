//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Дарья Савинкина on 09.10.2025.
//

import Foundation
import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?)
    
}
