import UIKit

protocol AlertPresenterProtocol {
    func present(
        currentGame: GameState,
        bestGame: GameResult,
        gamesCount: Int,
        accuracy: Double,
        kind: AlertKind,
        present: (UIViewController, Bool, (() -> Void)?) -> Void,
        buttonTapCompletion: (() -> Void)?,
        _ completion: (() -> Void)?
    )
}
