//import UIKit
//
//
//
//// MARK: - честно, так хочется попрятать все по extensionам, по файлам, по папкам...
//
//@preconcurrency @MainActor
//final class MovieQuizViewController: UIViewController {
//    
//    @IBOutlet private weak var staticQuestionLabel: UILabel!
//    
//    @IBOutlet private weak var dynamicQuizCounterLabel: UILabel!
//    @IBOutlet private weak var dynamicFilmCoverView: UIImageView!
//    @IBOutlet private weak var dynamicQuestionLabel: UILabel!
//    
//    @IBOutlet private weak var negativeButton: UIButton!
//    @IBOutlet private weak var positiveButton: UIButton!
//    
//    private var alertController: UIAlertController?
//    private var currentStat: QuizStatsModel = .init()
//    private var correctAnswersStats = [ Int ]()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.initialSetUp()
//    }
//    
//    private func initialSetUp() /*async*/ {
//        
//        // MARK: - for ex: get data and react
////        let result = NWService.shared.fetch( method: .GET, module: .films )
////        switch result {
////        case .success(let success):
////            <#code#>
////        case .failure(let failure):
////            <#code#>
////        }
//        
//        self.initialLabelsSetUp()
//        self.initialViewsSetUp()
//    }
//    
//}
//
//
//// MARK: - buttons handlers
//private extension MovieQuizViewController {
//    
//    @IBAction func positiveButtonTapped() {
//        self.handleButtonTapped(
//            mockQuizData[ currentStat.currentIndex ].correctAnswer == true
//        )
//    }
//    
//    @IBAction func negativeButtonTapped() {
//        self.handleButtonTapped(
//            mockQuizData[ currentStat.currentIndex ].correctAnswer == false
//        )
//    }
//    
//    
//    func handleButtonTapped( _ isCorrectAnswer: Bool ) {
//        
//        isCorrectAnswer ? self.currentStat.incrementCorrectAnswers() : nil
//        
//        UIView.animate( withDuration: 0.3 ) {
//            self.dynamicFilmCoverView.layer.borderColor = isCorrectAnswer ? UIColor.ysGreen.cgColor : UIColor.ysRed.cgColor
//            self.dynamicFilmCoverView.layer.borderWidth = 8
//        }
//        
//        self.switchButtonsAvailableState()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//            UIView.animate( withDuration: 0.3 ) {
//                self.dynamicFilmCoverView.layer.borderWidth = 0
//            }
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//            self.switchButtonsAvailableState()
//            self.tryShowQuestion()
//        }
//        
//    }
//    
//}
//
//
//
//// MARK: - helpers
//private extension MovieQuizViewController {
//    
//    func switchButtonsAvailableState() {
//        self.negativeButton.isUserInteractionEnabled.toggle()
//        self.positiveButton.isUserInteractionEnabled.toggle()
//    }
//    
//    func tryShowQuestion() {
//        self.currentStat.incrementCurrentIndex()
//        
//        if self.currentStat.currentIndex == mockQuizData.count {
//            self.prepareAlert()
//            guard let alertController else { return }
//            self.present(alertController, animated: true)
//        } else {
//            self.updateUI()
//        }
//    }
//    
//    func updateUI() {
//        UIView.animate( withDuration: 1 ) { [self] in
//            dynamicQuestionLabel.text = mockQuizData[ currentStat.currentIndex ].question
//            dynamicQuizCounterLabel.text = "\(currentStat.currentIndex + 1)/\(mockQuizData.count)"
//        }
//        
//        UIView.transition(
//            with: self.dynamicFilmCoverView,
//            duration: 0.3,
//            options: .transitionCrossDissolve
//        ){
//            self.dynamicFilmCoverView.image = mockQuizData[ self.currentStat.currentIndex ].image
//        }
//    }
//    
//    
//    func prepareAlert() {
//        
//        self.correctAnswersStats.append( self.currentStat.correctAnswers )
//        
//        let datetime = Date().dateTimeString
//        
//        let record = correctAnswersStats.max() ?? 0
//        let accuracy = String( format: "%.2f", Double(correctAnswersStats.reduce(0, +)) / Double(correctAnswersStats.count) * 10 )
//        
//        
//        self.alertController = UIAlertController(
//            title: "Этот раунд окончен!",
//            message:
//                "Ваш результат: \(currentStat.correctAnswers)/10\n" +
//            "Количество сыгранных квизов: \(correctAnswersStats.count)\n" +
//                        "Рекорд: \(record) (\(datetime))\n" +
//                          "Средняя точность: \(accuracy)%",
//            preferredStyle: .alert
//        )
//        
//        let alertAction = UIAlertAction(title: "Сыграть еще раз", style: .default) { _ in
//
//            self.currentStat.reset()
//            self.tryShowQuestion()
//            self.alertController = nil
//            
//        }
//        
//        self.alertController?.addAction( alertAction )
//        
//    }
//    
//}
//
//
//// MARK: - initialization
//private extension MovieQuizViewController {
//    
//    func initialViewsSetUp() {
//        
//        self.dynamicFilmCoverView.layer.masksToBounds = true
//        self.dynamicFilmCoverView.layer.borderWidth = GlobalConfig.dynamicFilmCoverViewLayerBorderWidth
//        self.dynamicFilmCoverView.layer.borderColor = UIColor.clear.cgColor
//        self.dynamicFilmCoverView.layer.cornerRadius = GlobalConfig.cornerRadius
//        
//        self.updateUI()
//        
//        self.negativeButton.layer.cornerRadius = GlobalConfig.cornerRadius
//        self.positiveButton.layer.cornerRadius = GlobalConfig.cornerRadius
//        
//    }
//    
//    func initialLabelsSetUp() {
//        
//        self.staticQuestionLabel.text = "Вопрос:"
//        self.dynamicQuizCounterLabel.text = "1/10"
//        self.dynamicQuestionLabel.text = "Рейтинг этого фильма меньше чем 5?"
//        
//        self.negativeButton.setTitle( "Нет", for: .normal )
//        self.positiveButton.setTitle( "Да",  for: .normal )
//        
//        self.staticQuestionLabel.textColor = .ysWhite
//        self.dynamicQuizCounterLabel.textColor = .ysWhite
//        self.dynamicQuestionLabel.textColor = .ysWhite
//        
//    }
//    
//}
//
//
//// MARK: - simple global config
//struct GlobalConfig {
//    static let cornerRadius: CGFloat = 15
//    static let dynamicFilmCoverViewLayerBorderWidth: CGFloat = 8
//}
//    
//    
//
//
///*
// Mock-данные
// 
// 
// Картинка: The Godfather
// Настоящий рейтинг: 9,2
// Вопрос: Рейтинг этого фильма больше чем 6?
// Ответ: ДА
// 
// 
// Картинка: The Dark Knight
// Настоящий рейтинг: 9
// Вопрос: Рейтинг этого фильма больше чем 6?
// Ответ: ДА
// 
// 
// Картинка: Kill Bill
// Настоящий рейтинг: 8,1
// Вопрос: Рейтинг этого фильма больше чем 6?
// Ответ: ДА
// 
// 
// Картинка: The Avengers
// Настоящий рейтинг: 8
// Вопрос: Рейтинг этого фильма больше чем 6?
// Ответ: ДА
// 
// 
// Картинка: Deadpool
// Настоящий рейтинг: 8
// Вопрос: Рейтинг этого фильма больше чем 6?
// Ответ: ДА
// 
// 
// Картинка: The Green Knight
// Настоящий рейтинг: 6,6
// Вопрос: Рейтинг этого фильма больше чем 6?
// Ответ: ДА
// 
// 
// Картинка: Old
// Настоящий рейтинг: 5,8
// Вопрос: Рейтинг этого фильма больше чем 6?
// Ответ: НЕТ
// 
// 
// Картинка: The Ice Age Adventures of Buck Wild
// Настоящий рейтинг: 4,3
// Вопрос: Рейтинг этого фильма больше чем 6?
// Ответ: НЕТ
// 
// 
// Картинка: Tesla
// Настоящий рейтинг: 5,1
// Вопрос: Рейтинг этого фильма больше чем 6?
// Ответ: НЕТ
// 
// 
// Картинка: Vivarium
// Настоящий рейтинг: 5,8
// Вопрос: Рейтинг этого фильма больше чем 6?
// Ответ: НЕТ
//*/
//
