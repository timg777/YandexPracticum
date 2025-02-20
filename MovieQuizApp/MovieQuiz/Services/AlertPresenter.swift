import UIKit

final class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    
    private func buildReport(
        currentGame: GameState,
        bestGame: GameResult,
        gamesCount: Int,
        accuracy: Double
    ) -> String {
        return """
           Ваш результат: \(currentGame.correctAnswers)/\(bestGame.totalQuestions)
            Количество сыгранных квизов: \(gamesCount)
            Рекорд: \(bestGame.correctAnswers)/\(bestGame.totalQuestions) (\(bestGame.date))
            Средняя точность: \(String(format: "%.2f", accuracy))%
        """
    }
    
    private func configure(
        header: String,
        body: String,
        buttonText: String,
        isError: Bool
    ) -> UIAlertController {
        
        let alert = UIAlertController(title: header, message: body, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .cancel) { [weak self] _ in
            guard let self else { return }
            isError ? delegate?.didTappedAlertRetryButton() : delegate?.didTappedAlertResetButton()
            alert.dismiss(animated: true)
        }
        alert.addAction( action )
        return alert
    }
    
    func present(
        currentGame: GameState,
        bestGame: GameResult,
        gamesCount: Int,
        accuracy: Double,
        kind: AlertKind,
        present: (UIViewController, Bool, (() -> Void)?) -> Void,
        _ completion: (() -> Void)? = nil
    ) {
        
        let report = buildReport(
            currentGame: currentGame,
            bestGame: bestGame,
            gamesCount: gamesCount,
            accuracy: accuracy
        )
        let alertBody = kind == .report ? kind.body(report: report) : kind.body()
        let alert = configure(
            header: kind.header,
            body: alertBody,
            buttonText: kind.buttonText,
            isError: kind != .report
        )
        present(alert, true, completion)
    }
}
