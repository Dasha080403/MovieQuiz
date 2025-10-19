//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Дарья Савинкина on 13.10.2025.
//

import Foundation
import UIKit

protocol StatisticServiceProtocol{
    var allGamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
