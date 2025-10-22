//
//  MovieQuizPresenter.swift.swift
//  MovieQuiz
//
//  Created by Дарья Савинкина on 21.10.2025.
//
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    
    private let statisticService: StatisticServiceProtocol!

    
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    var currentQuestion: QuizQuestion?
    
    weak var viewController: MovieQuizViewController?
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
   
    init(viewController: MovieQuizViewControllerProtocol) {
        
        self.viewController = viewController as? MovieQuizViewController
          
        statisticService = StatisticService()

        
          questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
          questionFactory?.loadData()
          viewController.showLoadingIndicator()
      }
    
    
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
         
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func isLastQuestion() -> Bool {
           currentQuestionIndex == questionsAmount
       }
    
    func isFirstQuestion() -> Bool {
           currentQuestionIndex == 0
       }
       
       func resetQuestionIndex() {
           currentQuestionIndex = 0
       }
       
       func switchToNextQuestion() {
           currentQuestionIndex += 1
       }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            viewController?.endGame()
        } else {
            questionFactory?.requestNextQuestion()
        }
    }
    
    func restartGame() {
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
    
    func makeResultsMessage() -> String {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let bestGame = statisticService.bestGame
            
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.allGamesCount)"
            let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
            + " (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let resultMessage = [
                currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")
            
            return resultMessage
        }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers+=1
        }
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.showNextQuestionOrResults()
            }
        self.switchToNextQuestion()
        }

    
    // MARK: - QuestionFactoryDelegate
        
    func didLoadDataFromServer() {
            viewController?.hideLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
        
    func didFailToLoadData(with error: Error) {
            let message = error.localizedDescription
            viewController?.showNetworkError(message: message)
        }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        self.currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }

}

