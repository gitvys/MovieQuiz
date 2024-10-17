//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Владислав Соколов on 17.10.2024.
//

import UIKit

final class MovieQuizPresenter {
    
    // переменная с индексом текущего вопроса, начальное значение 0
    private var currentQuestionIndex = 0
    
    // кол-во вопросов
    let questionsAmount:Int = 10
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.question,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
}
