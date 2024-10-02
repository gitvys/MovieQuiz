//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Владислав Соколов on 22.09.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion (question: QuizQuestion?)
}
