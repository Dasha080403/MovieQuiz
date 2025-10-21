//
//  MovieQuizPresenter.swift.swift
//  MovieQuiz
//
//  Created by Дарья Савинкина on 21.10.2025.
//
import UIKit

final class MovieQuizPresenter {
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
   
     func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
        }
    
    func noButtonClicked() {
            didAnswer(isYes: false)
        }
    
    func didAnswer(isYes: Bool){
        guard let currentQuestion = currentQuestion else {
                    return
        }
                
        let givenAnswer = isYes
                
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func isLastQuestion() -> Bool {
           currentQuestionIndex == questionsAmount - 1
       }
       
       func resetQuestionIndex() {
           currentQuestionIndex = 0
       }
       
       func switchToNextQuestion() {
           currentQuestionIndex += 1
       }
}

