import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
//  Untitled.swift
//  MovieQuiz
//
//  Created by Дарья Савинкина on 08.10.2025.
//

