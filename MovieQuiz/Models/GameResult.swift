//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Владислав Соколов on 03.10.2024.
//

import UIKit

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func checkBestGame(lastGame: GameResult) -> Bool {
        correct > lastGame.correct
    }
}

