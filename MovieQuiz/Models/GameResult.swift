//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Дарья Савинкина on 13.10.2025.
//
import Foundation
import UIKit


struct GameResult : Decodable, Encodable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        return correct > another.correct
    }
}
