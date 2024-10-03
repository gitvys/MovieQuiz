import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IBOutlet
    
    @IBOutlet weak private var indexLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    // MARK: - Private Properties
    
    // переменная с индексом текущего вопроса, начальное значение 0
    private var currentQuestionIndex = 0
    
    // счётчик правильных ответов
    private var correctAnswers = 0
    
    // кол-во вопросов
    private var questionsAmount:Int = 10
    
    // обращение к фабрике вопросов
    private var questionFactory: QuestionFactoryProtocol?
    
    // обращение к алерту
    private var alertPresenter: AlertPresenter?
    
    // текущий вопрос пользователя, который он видит
    private var currentQuestion: QuizQuestion?
    
    // создание экземпляра
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory()
            questionFactory.delegate = self
            self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
        // Подтянул презентер, self потому что вызов "здесь"
        self.alertPresenter = AlertPresenter (viewController: self)
    }
        
    // MARK: - QuestionFactoryDelegate
    // текущий вопрос определяет фабрика и отправляет его контроллеру, который будет работать над отображением
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
        // MARK: - IBActions
        
        @IBAction private func yesButtonClicked(_ sender: Any) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let answer = true
            showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
            disableButtons()
        }
        
        @IBAction private func noButtonClicked(_ sender: Any) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            let answer = false
            showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
            disableButtons()
        }
        
        // MARK: - Private Methods
        
        private func convert(model: QuizQuestion) -> QuizStepViewModel {
            let questionStep = QuizStepViewModel(
                image: UIImage(named: model.image) ?? UIImage(),
                question: model.question,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
            return questionStep
        }
        
        private func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            indexLabel.text = step.questionNumber
            questionLabel.text = step.question
        }
        
        private func showAnswerResult(isCorrect: Bool) {
            imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
            imageView.layer.borderWidth = 8 // толщина рамки
            imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
            if isCorrect == true {
                imageView.layer.borderColor = UIColor.ypGreen.cgColor
                correctAnswers += 1
            }
            else {
                imageView.layer.borderColor = UIColor.ypRed.cgColor
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.showNextQuestionOrResults()
            }
        }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let formattedDate = statisticService.bestGame.date.dateTimeString
            let text = "Ваш результат: \(correctAnswers)/\(statisticService.bestGame.total) \n Количество сыгранных кизов: \(statisticService.gamesCount) \n Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(formattedDate) \n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            // здесь нужно создать экземпляр алерта
            let alertModel = AlertModel (title: "Этот раунд окончен!",
                                         message: text,
                                         buttonText: "Сыграть еще раз",
                                         completion: {
                [weak self] in
                self?.restartQuiz() }
            // здесь вызов функции, которая перезапустит квиз
            )
            // сходить туда сказать, что мы показываем алерт
            alertPresenter?.showAlert(model: alertModel)
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
            imageView.layer.borderWidth = 0
            enableButtons()
        }
    }
    
        // что делать, если квиз перезапущен
        private func restartQuiz() {
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
            imageView.layer.borderWidth = 0
            enableButtons()
        }
        
        private func disableButtons () {
            noButton.isEnabled = false
            yesButton.isEnabled = false
        }
        
        private func enableButtons () {
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
        
}
