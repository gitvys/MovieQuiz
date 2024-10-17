import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet weak private var indexLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - IBActions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Private Methods
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        indexLabel.text = step.questionNumber
        questionLabel.text = step.question
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
        presenter.questionFactory?.loadData() // чтобы алерт вызывался до момента, пока данные не будут загружены, а не 1 раз
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    
    func hideBorder() {
        imageView.layer.borderWidth = 0
    }
    
     func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertModel = AlertModel (title: "Ошибка",
                                     message: message,
                                     buttonText: "Попробовать еще раз",
                                     completion: {
            [weak self] in
            self?.presenter.refreshNumbers()
            self?.showLoadingIndicator()
        }
        )
        // показываем алерт
         presenter.alertPresenter?.showAlert(model: alertModel)
    }
    
    func disableButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func enableButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
}
