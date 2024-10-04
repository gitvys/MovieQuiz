//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Владислав Соколов on 03.10.2024.
//

import UIKit

final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case correctAnswers
    }
    
    private var correctAnswers: Int {
            get {
                storage.integer(forKey: Keys.correctAnswers.rawValue)
            }
            set {
                storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
            }
        }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: "bestGame.correct")
            let total = storage.integer(forKey: "bestGame.total")
            let date = storage.object(forKey: "bestGame.date") as? Date ?? Date()
            // Добавьте чтение значений полей GameResult(correct, total и date) из UserDefaults,
            return GameResult(correct: correct, total: total, date: date)
            // затем создайте GameResult от полученных значений
        }
        set {
            // Добавьте запись значений каждого поля из newValue из UserDefaults
            storage.set(newValue.correct, forKey: "bestGame.correct")
            storage.set(newValue.total, forKey: "bestGame.total")
            storage.set(newValue.date, forKey: "bestGame.date")
        }
    }
    
    var totalAccuracy: Double {
        get {
            guard gamesCount > 0 && bestGame.total > 0 else {
                return 0.0
            }
            let totalAccuracy = (Double(correctAnswers) / Double(bestGame.total * gamesCount)) * 100
            return totalAccuracy
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        correctAnswers += count
        gamesCount += 1
        if count > bestGame.correct {
           let newBestGame = GameResult(correct: count, total: amount, date: Date())
            bestGame = newBestGame
        }
    }

}
