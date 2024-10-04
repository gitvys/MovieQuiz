//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Владислав Соколов on 01.10.2024.
//

import UIKit

final class AlertPresenter: AlertProtocol {
    // обращение к классу, который будет использовать алерт, когда понадобится
    weak var viewController: MovieQuizViewController?
    
    init(viewController: MovieQuizViewController? = nil) {
        self.viewController = viewController
    }
    
    // приватный метод для показа результатов раунда квиза
    // переписать так, чтобы обращения здесь шли к созданной структуре а не создавались напрямую
    func showAlert(model: AlertModel) {
        // создаем алерт
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert) // .alert или .actionSheet
        // создаем действие кнопки
        // вызов замыкания, которое будет перезапускать квиз
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        // создаем кнопку
        alert.addAction(action)
        // отдаем алерт на экран через основной контроллер
        viewController?.present(alert, animated: true, completion: nil)
    }
}
