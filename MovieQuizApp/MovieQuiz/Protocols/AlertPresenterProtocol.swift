import UIKit

protocol AlertPresenterProtocol {
    func present(
        report: String,
        kind: AlertKind,
        present: (UIViewController, Bool, (() -> Void)?) -> Void,
        showUI: @escaping () -> (),
        _ completion: (() -> Void)?
    )
}
