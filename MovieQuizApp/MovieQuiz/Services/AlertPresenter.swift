import UIKit



final class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
}



extension AlertPresenter {
    
    private func configure(
        header: String,
        body: String,
        buttonText: String,
        isError: Bool,
        showUI: @escaping () -> ()
    ) -> UIAlertController {
        let alert = UIAlertController(title: header, message: body, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default) { [weak self] _ in
            guard let self else { return }
            showUI()
            !isError ? delegate?.didTappedAlertButton() : ()
            alert.dismiss(animated: true)
        }
        alert.addAction( action )
        return alert
    }
    
    func present(
        report: String,
        kind: AlertKind,
        present: (UIViewController, Bool, (() -> Void)?) -> Void,
        showUI: @escaping () -> Void,
        _ completion: (() -> Void)? = nil
    ) {
        
        let alertBody = kind == .report ? kind.body(report: report) : kind.body()
        let alert = configure(
            header: kind.header,
            body: alertBody,
            buttonText: kind.buttonText,
            isError: kind == .error,
            showUI: showUI
        )
        present(alert, true, completion)
    }
    
}
