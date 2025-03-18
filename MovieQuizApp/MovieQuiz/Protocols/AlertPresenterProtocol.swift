import UIKit

protocol AlertPresenterProtocol {
    func present(
        currentGame: GameState,
        bestGame: GameResult,
        gamesCount: Int,
        accuracy: Double,
        kind: AlertKind,
        present: @MainActor (UIViewController, Bool, (() -> Void)?) -> Void,
        _ completion: (() -> Void)?
    )
}
