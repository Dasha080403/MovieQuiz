//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Дарья Савинкина on 13.10.2025.
//
import Foundation
import UIKit


public final class StatisticService: StatisticServiceProtocol {
    
    private enum Keys: String {
        case allGamesCount          // Для счётчика сыгранных игр.
        case bestGameCorrectAnswers     // Для количества правильных ответов в лучшей игре.
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры.
        case totalCorrectAnswersAllGames // Для общего количества правильных ответов за все игры.
        case totalQuestionsAskedAllGames // Для общего количества вопросов, заданных за все игры.
        case savedGames          // Для сохранения массива игр.
        case bestGame            // Для сохранения лучшей игры.
    }
    private var games: [GameResult] = []
    private let storage: UserDefaults = .standard
    
    var bestGame: GameResult {
        get {
            let correct = UserDefaults.standard.integer(forKey: Keys.bestGameCorrectAnswers.rawValue)
            let total = UserDefaults.standard.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = UserDefaults.standard.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            UserDefaults.standard.set(newValue.correct, forKey: Keys.bestGameCorrectAnswers.rawValue)
            UserDefaults.standard.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            UserDefaults.standard.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var allGamesCount: Int{
        get{
            storage.integer(forKey: Keys.allGamesCount.rawValue)
        }set{
            storage.set(newValue, forKey: Keys.allGamesCount.rawValue)
        }
    }
    var totalAccuracy: Double{
        guard totalQuestionsAskedAllGames > 0 else {
            return 0.0
        }
        return Double(totalCorrectAnswersAllGames)/Double(totalQuestionsAskedAllGames) * 100
    }
    
    var totalCorrectAnswersAllGames: Int{
        get{
            return storage.integer(forKey: Keys.totalCorrectAnswersAllGames.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.totalCorrectAnswersAllGames.rawValue)
        }
    }
    var totalQuestionsAskedAllGames: Int{
        get{
            return storage.integer(forKey: Keys.totalQuestionsAskedAllGames.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.totalQuestionsAskedAllGames.rawValue)
        }
    }
    
    
    func store(correct count: Int, total amount: Int) {
        print("Storing game result: (count) correct out of (amount) total")

        let newGameResult = GameResult(correct: count, total: amount, date: Date())

        games.append(newGameResult)
        allGamesCount += 1

        if allGamesCount == 1 {
            bestGame = newGameResult
            print("First game recorded as best game: (bestGame)")
        } else if bestGame.correct < count {
            print("New best game found: (newGameResult)")
            bestGame = newGameResult
        }

        totalCorrectAnswersAllGames += count
        totalQuestionsAskedAllGames += amount
    }
    }



    

        
            
           
            

            
            
            
            
        
    

