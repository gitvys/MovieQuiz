//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Владислав Соколов on 07.09.2024.
//

import UIKit

// структура вопроса - картинка, текст вопроса и правильность
struct QuizQuestion {
    // строка с названием фильма,
    // совпадает с названием картинки афиши фильма в Assets
    let image: Data
    // строка с вопросом о рейтинге фильма
    let question: String
    // булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}
