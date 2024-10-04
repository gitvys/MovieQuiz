//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Владислав Соколов on 01.10.2024.
//

import UIKit

// вью модель для состояния "Вопрос показан"
struct AlertModel {
    // наименование алерта
    let title: String
    // текст алерта
    let message: String
    // текст для кнопки
    let buttonText: String
    // замыкание без параметров для действия при нажатии на кнопку
    let completion: () -> Void
}
