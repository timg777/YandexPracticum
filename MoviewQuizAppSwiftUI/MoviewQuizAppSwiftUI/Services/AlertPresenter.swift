import SwiftUI

struct AlertPresenter: ViewModifier {
    var isPresented: Binding<Bool>
    var currentGame: Binding<GameState>
    let bestGame: GameResult
    let gamesCount: Int
    let accuracy: Double
    var alertKind: Binding<AlertKind?>
    var report: String {
        """
           Ваш результат: \(currentGame.wrappedValue.correctAnswers)/\(bestGame.totalQuestions)
            Количество сыгранных квизов: \(gamesCount)
            Рекорд: \(bestGame.correctAnswers)/\(bestGame.totalQuestions) (\(bestGame.date))
            Средняя точность: \(String(format: "%.2f", accuracy))%
        """
    }
    
    func body(content: Content) -> some View {
        if let alertKind {
            content
                .alert(alertKind.wrappedValue?.header ?? "", isPresented: isPresented) {
                    Button {
                        isPresented.wrappedValue = false
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentGame.wrappedValue.reset()
                        }
                    } label: {
                        Text(alertKind.wrappedValue?.buttonText ?? "")
                            .bold()
                    }
                } message: {
                    if let alertKind = alertKind.wrappedValue {
                        alertKind == .report ? Text(report) : Text(alertKind.body())
                    }
                }
        } else {
            content
        }
    }
}


extension View {
    func alertPresenter(
        isPresented: Binding<Bool>,
        currentGame: Binding<GameState>,
        bestGame: GameResult,
        gamesCount: Int,
        accuracy: Double,
        alertKind: Binding<AlertKind?>
    ) -> some View {
        self
            .modifier(
                AlertPresenter(
                    isPresented: isPresented,
                    currentGame: currentGame,
                    bestGame: bestGame,
                    gamesCount: gamesCount,
                    accuracy: accuracy,
                    alertKind: alertKind
                )
            )
    }
}
