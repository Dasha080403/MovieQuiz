import UIKit
import Foundation


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    private enum Fonts {
        static let base = UIFont(name: "YSDisplay-Medium", size: 20) ?? UIFont.systemFont(ofSize:20, weight: .medium)
        static let bold = UIFont(name: "YSDisplay-Bold", size: 23) ?? UIFont.systemFont(ofSize:23, weight: .bold)
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
            
        presenter = MovieQuizPresenter(viewController: self)
        
        print(NSHomeDirectory())
        UserDefaults.standard.set(true, forKey: "viewDidLoad")
        
        presenter.showNextQuestionOrResults()
        yesButton.titleLabel?.font = Fonts.base
        noButton.titleLabel?.font = Fonts.base
        textLabel.font = Fonts.bold
        counterLabel.font = Fonts.base
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 20
        questionLabel.font = Fonts.base
        setImageBorder(isAnswered: false)
        
        showLoadingIndicator()
        presenter.questionFactory?.loadData()
        
    }
    

    var statisticService: StatisticServiceProtocol = StatisticService()
    private var alertPresenter = AlertPresenter()

    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var presenter: MovieQuizPresenter!

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    func hideLoadingIndicator() {
           activityIndicator.isHidden = true
       }
    
    func showNetworkError (message: String){
        hideLoadingIndicator()
        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз", completion: {[weak self] in
            guard let self = self else {
                return
            }
            presenter.restartGame()
        })
        alertPresenter.show(in: self, model: alertModel)
    }
    
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func setImageBorder(isAnswered: Bool) {
        if isAnswered {
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.green.cgColor
        } else {
            imageView.layer.borderWidth = 0
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
           imageView.layer.masksToBounds = true
           imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.YPGreen?.cgColor : UIColor.YPRed?.cgColor
       }
       
    
    func show(quiz: QuizStepViewModel){
        imageView.image = quiz.image
        counterLabel.text = quiz.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.borderWidth = 1
    }
    
    func endGame() {
        statisticService.store(correct: presenter.correctAnswers, total: questionsAmount )
        let message = presenter.makeResultsMessage()
        
        let alertModel = AlertModel(
            title: "Игра окончена",
            message: message,
            buttonText: "Начать заново",
            completion: {[weak self] in
                guard let self = self else { return }
                presenter.restartGame()
                presenter.showNextQuestionOrResults()
            })
        alertPresenter.show(in: self, model: alertModel)
        }
}


