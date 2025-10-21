import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate{
    private enum Fonts {
        static let base = UIFont(name: "YSDisplay-Medium", size: 20) ?? UIFont.systemFont(ofSize:20, weight: .medium)
        static let bold = UIFont(name: "YSDisplay-Bold", size: 23) ?? UIFont.systemFont(ofSize:23, weight: .bold)
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
       
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        
        print(NSHomeDirectory())
        UserDefaults.standard.set(true, forKey: "viewDidLoad")
        
        showCurrentQuestion()
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
        questionFactory.loadData()
        
    }
    

    var statisticService: StatisticServiceProtocol = StatisticService()
    private var alertPresenter = AlertPresenter()
    private var questionFactory: QuestionFactoryProtocol?
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    
    private var correctAnswers = 0
    private var currentQuestionIndex = 0

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
            questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError (message: String){
        hideLoadingIndicator()
        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз", completion: {[weak self] in
            guard let self = self else {
                return
            }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter.show(in: self, model: alertModel)
    }
    
    private func showLoadingIndicator() {
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
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
              return
          }

          currentQuestion = question
          let viewModel = convert(model: question)
          show(quiz: viewModel)
    }
    
    func show(quiz: QuizStepViewModel){
        imageView.image = quiz.image
        counterLabel.text = quiz.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.borderWidth = 1
        
    }
  
    
    private func showCurrentQuestion() {
        questionFactory?.requestNextQuestion()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        setImageBorder(isAnswered: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                self.showNextQuestionOrResults()
            }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.YPGreen?.cgColor : UIColor.YPRed?.cgColor
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
          endGame()
        } else {
            currentQuestionIndex += 1
            showCurrentQuestion()
        }
    }
    func endGame() {
        statisticService.store(correct: correctAnswers, total: questionsAmount )
        let message = """
            Ваш результат: \(correctAnswers) правильных ответов
            Рекорд: \(statisticService.bestGame.correct) из \(questionsAmount) (дата: \(statisticService.bestGame.date))
            Сыграно квизов: \(statisticService.allGamesCount)
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
        
        let alertModel = AlertModel(
            title: "Игра окончена",
            message: message,
            buttonText: "Начать заново",
            completion: {[weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.resetQuestionIndex()
                self.showCurrentQuestion()
            })
        alertPresenter.show(in: self, model: alertModel)
        }
}


