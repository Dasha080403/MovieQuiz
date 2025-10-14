class showNextQuestionOrResults {
    private func showNextQuestionOrResults() {
        if self.currentQuestionIndex == questions.count - 1 {
            showResults()
        } else {
            currentQuestionIndex += 1
            showCurrentQuestion()
        }
    }
}
//  Untitled.swift
//  MovieQuiz
//
//  Created by Дарья Савинкина on 08.10.2025.
//

