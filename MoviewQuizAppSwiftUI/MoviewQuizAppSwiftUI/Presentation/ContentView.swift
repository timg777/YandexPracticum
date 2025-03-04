import SwiftUI

struct ContentView: View {
    
    // MARK: - state variables
    @State private var isCorrectAnswerAnimate: Bool?
    @StateObject private var statistic = StatisticService()
    @StateObject private var questionFactory = QuestionFactory()
    @State private var alertIsPresented = false
    @State private var alertKind: AlertKind?
    
    // MARK: - constants
    private let totalQuestionsCount: Int = 10
    
    // MARK: - view
    @ViewBuilder
    var body: some View {
        ZStack {
            Color.ysBlack.ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    staticQuestionLabelView
                    Spacer()
                    dynamicQuizCounterLabelView
                }
                dynamicFilmCoverView
                Spacer()
                dynamicQuestionLabelView
                Spacer()
                HStack(spacing: 20) {
                    negativeButtonView
                    positiveButtonView
                }
            }
            .padding(.horizontal, 20)
        }
        .alertPresenter(
            isPresented: $alertIsPresented,
            currentGame: $statistic.currentGame,
            bestGame: statistic.bestGame,
            gamesCount: statistic.gamesCount,
            accuracy: statistic.totalAccuracy,
            alertKind: $alertKind
        )
    }
    
    
}

// MARK: - subviews
private extension ContentView {
    
    @ViewBuilder
    var staticQuestionLabelView: some View {
        Text("Вопрос:")
            .foregroundStyle(.ysWhite)
            .font(.ysDisplayMedium)
    }
    
    @ViewBuilder
    var dynamicQuizCounterLabelView: some View {
        Text("\(statistic.currentGame.questionIndex + 1)/10")
            .foregroundStyle(.ysWhite)
            .font(.ysDisplayBold)
    }
    
    @ViewBuilder
    var dynamicFilmCoverView: some View {
        Image(questionFactory.currentQuestion?.imageString ?? "")
            .resizable()
            .aspectRatio(0.7, contentMode: .fit)
            .overlay {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.clear)
                    .stroke(isCorrectAnswerAnimate != nil ? isCorrectAnswerAnimate! ? Color.green : Color.red : Color.clear, lineWidth: isCorrectAnswerAnimate != nil ? 17 : 0 )
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    @ViewBuilder
    var dynamicQuestionLabelView: some View {
        Text(questionFactory.currentQuestion?.question ?? "")
            .foregroundStyle(.ysWhite)
            .font(.ysDisplayBold)
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    var negativeButtonView: some View {
        Button {
            answerHandler(questionFactory.currentQuestion?.correctAnswer ?? false)
        } label: {
            Text("Нет")
                .font(.ysDisplayMedium)
        }
        .buttonStyle(MovieQuizButtonStyle())
        .disabled(isCorrectAnswerAnimate != nil)
    }
    
    @ViewBuilder
    var positiveButtonView: some View {
        Button {
            answerHandler(questionFactory.currentQuestion?.correctAnswer ?? false)
        } label: {
            Text("Да")
                .font(.ysDisplayMedium)
        }
        .buttonStyle(MovieQuizButtonStyle())
        .disabled(isCorrectAnswerAnimate != nil)
    }
}

// MARK: - private functions
private extension ContentView {
    
    func answerHandler(_ isCorrentAnswer: Bool) {
        if isCorrentAnswer { statistic.incCurrentCorrectAnswers() }
        
        withAnimation(.easeInOut(duration: 0.15)) {
            isCorrectAnswerAnimate = isCorrentAnswer
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isCorrectAnswerAnimate = nil
                
                if statistic.currentGame.questionIndex == 9 {
                    statistic.resetGameState()
                    alertIsPresented = true
                } else {
                    statistic.incCurrentQuestionIndex()
                }
                statistic.objectWillChange.send()
            }
        }
    }
}

#Preview {
    ContentView()
}
