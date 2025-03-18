protocol MovieQuizPresenterProtocol {
    func handleButtonTapped(_ isPositiveButton: Bool)
    func presentAlert(kind: AlertKind)
    func anErrorOccuredScenario(localizedDescription: String)
}
