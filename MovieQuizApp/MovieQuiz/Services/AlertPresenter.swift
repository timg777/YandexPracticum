import UIKit

final class AlertPresenter {

    // MARK: - AlertPresenter staff here
    
}

// MARK: - Extensions + AlertPresenterProtocol Conformance
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
        buttonTapCompletion: (() -> Void)?
    ) -> UIAlertController {
        
        let alert = UIAlertController(title: header, message: body, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .cancel) { [weak self] _ in
            guard let self else { return }
            buttonTapCompletion?()
            alert.dismiss(animated: true)
        }
        action.accessibilityIdentifier = AccessibilityElement.alertOKButton.identifier
        alert.addAction( action )
        return alert
    }
    
    @MainActor
    @preconcurrency
    func present(
        currentGame: GameState,
        bestGame: GameResult,
        gamesCount: Int,
        accuracy: Double,
        kind: AlertKind,
        present: @MainActor (UIViewController, Bool, (() -> Void)?) -> Void,
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
            buttonTapCompletion: completion
        )
        present(alert, true, nil)
    }
    
}
