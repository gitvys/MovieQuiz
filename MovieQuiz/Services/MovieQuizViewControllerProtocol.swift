//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Владислав Соколов on 17.10.2024.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func hideLoadingIndicator()
    func hideBorder()
    func showLoadingIndicator()
    
    func enableButtons()
    func disableButtons()
    
    func showNetworkError(message: String)
}
