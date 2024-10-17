import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IBOutlet
    
    @IBOutlet weak private var indexLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    
    // счётчик правильных ответов
    private var correctAnswers = 0
    
    // обращение к фабрике вопросов
    private var questionFactory: QuestionFactoryProtocol?
    
    // обращение к алерту
    private var alertPresenter: AlertPresenter?
    
    // текущий вопрос пользователя, который он видит
    private var currentQuestion: QuizQuestion?
    
    // создание экземпляра
    private let statisticService: StatisticServiceProtocol = StatisticService()
    
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        //        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        //        questionFactory.requestNextQuestion()
        //        // Подтянул презентер, self потому что вызов "здесь"
        self.alertPresenter = AlertPresenter (viewController: self)
        
        showLoadingIndicator()
        questionFactory.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    // текущий вопрос определяет фабрика и отправляет его контроллеру, который будет работать над отображением
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
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
        if presenter.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            let formattedDate = statisticService.bestGame.date.dateTimeString
            let text = "Ваш результат: \(correctAnswers)/\(statisticService.bestGame.total) \n Количество сыгранных кизов: \(statisticService.gamesCount) \n Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(formattedDate) \n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            // здесь нужно создать экземпляр алерта
            let alertModel = AlertModel (title: "Этот раунд окончен!",
                                         message: text,
                                         buttonText: "Сыграть еще раз",
                                         completion: {
                [weak self] in
                // здесь вызов функции, которая перезапустит квиз
                self?.restartQuiz() }
            )
            // сходить туда сказать, что мы показываем алерт
            alertPresenter?.showAlert(model: alertModel)
        } else {
            presenter.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
            imageView.layer.borderWidth = 0
            enableButtons()
        }
    }
    
    // что делать, если квиз перезапущен
    private func restartQuiz() {
        presenter.resetQuestionIndex()
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
        imageView.layer.borderWidth = 0
        enableButtons()
    }
    
    private func disableButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    private func enableButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
        
        questionFactory?.loadData() // чтобы алерт вызывался до момента, пока данные не будут загружены, а не 1 раз
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        let alertModel = AlertModel (title: "Ошибка",
                                     message: message,
                                     buttonText: "Попробовать еще раз",
                                     completion: {
            [weak self] in
            self?.presenter.resetQuestionIndex()
            self?.correctAnswers = 0
            self?.showLoadingIndicator()
        }
        )
        // показываем алерт
        alertPresenter?.showAlert(model: alertModel)
    }
    
}
