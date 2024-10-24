//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Владислав Соколов on 17.10.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Properties
    // переменная с индексом текущего вопроса, начальное значение 0
    private var currentQuestionIndex = 0
    
    // кол-во вопросов
    private let questionsAmount:Int = 10
    
    // счётчик правильных ответов
    private var correctAnswers = 0
    
    // текущий вопрос пользователя, который он видит
    private var currentQuestion: QuizQuestion?
    
    // обращение к контроллеру
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    // обращение к фабрике вопросов
    var questionFactory: QuestionFactoryProtocol?
    
    // обращение к алерту
    var alertPresenter: AlertPresenter?
    
    // создание экземпляра
    private let statisticService: StatisticServiceProtocol!
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        if let viewController = viewController as? MovieQuizViewController {
            alertPresenter = AlertPresenter(viewController: viewController)
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    // MARK: - IBActions
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // MARK: - Public Methods
    private func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let isCorrect = (isYes == currentQuestion.correctAnswer)
        
        if isCorrect {
            correctAnswers += 1
        }
        
        proceedWithAnswer(isCorrect: isCorrect)
        viewController?.disableButtons()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.question,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            let message = makeResultsMessage()
            
            let alertModel = AlertModel (title: "Этот раунд окончен!",
                                         message: message,
                                         buttonText: "Сыграть еще раз",
                                         completion: {
                [weak self] in
                // здесь вызов функции, которая перезапустит квиз
                self?.restartQuiz() }
            )
            // сходить туда сказать, что мы показываем алерт
            alertPresenter?.showAlert(model: alertModel)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            viewController?.hideBorder()
            viewController?.enableButtons()
        }
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func refreshNumbers() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func restartQuiz() {
        refreshNumbers()
        questionFactory?.requestNextQuestion()
        viewController?.hideBorder()
        viewController?.enableButtons()
        
    }
}
