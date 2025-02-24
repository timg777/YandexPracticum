import SwiftUI

struct ContentView: View {
    
    // MARK: - state variables
    @State private var currentIndex = 0
    @State private var isCorrectAnswerAnimate: Bool?
    @State private var statistic = [QuizStatsModel]()
    @State private var currentStat = QuizStatsModel()
    @State private var alertIsPresented = false
    
    // MARK: - constants
    private let totalQuestionsCount: Int = 10
    
    // MARK: - computed variables
    var generateAlertMessage: String {
        let accuracy = Double(statistic.map {$0.correctAnswers}.reduce(0, +)) / Double(statistic.count) * 10
        let recordStat = statistic.max(by: {$0.correctAnswers < $1.correctAnswers}) ?? QuizStatsModel()
        
        return """
           Ваш результат: \(currentStat.correctAnswers)/\(totalQuestionsCount)
            Количество сыгранных квизов: \(statistic.count)
            Рекорд: \(recordStat.correctAnswers)/\(totalQuestionsCount) (\(recordStat.dateString ?? "no date"))
            Средняя точность: \(String(format: "%.2f", accuracy))%
        """
    }
    
    // MARK: - view
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
        .alert("Этот раунд окончен!", isPresented: $alertIsPresented) {
            Button {
                alertIsPresented = false
                currentStat = .init()
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentIndex = 0
                }
            } label: {
                Text("Сыграть еще раз")
                    .bold()
            }
            
        } message: {
            Text(generateAlertMessage)
                .multilineTextAlignment(.center)
        }
        
    }
    
    // MARK: - subviews
    private var staticQuestionLabelView: some View {
        Text("Вопрос:")
            .foregroundStyle(.ysWhite)
            .font(.ysDisplayMedium)
    }
    
    private var dynamicQuizCounterLabelView: some View {
        Text("\(currentIndex + 1)/10")
            .foregroundStyle(.ysWhite)
            .font(.ysDisplayBold)
    }
    
    private var dynamicFilmCoverView: some View {
        Image(uiImage: mockQuizData[currentIndex].image)
            .resizable()
            .aspectRatio(0.7, contentMode: .fit)
            .overlay {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.clear)
                    .stroke(isCorrectAnswerAnimate != nil ? isCorrectAnswerAnimate! ? Color.green : Color.red : Color.clear, lineWidth: isCorrectAnswerAnimate != nil ? 17 : 0 )
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    private var dynamicQuestionLabelView: some View {
        Text( mockQuizData[currentIndex].question )
            .foregroundStyle(.ysWhite)
            .font(.ysDisplayBold)
            .multilineTextAlignment(.center)
    }
    
    private var negativeButtonView: some View {
        Button {
            answerHandler(!mockQuizData[currentIndex].correctAnswer)
        } label: {
            Text("Нет")
                .font(.ysDisplayMedium)
        }
        .buttonStyle(MovieQuizButtonStyle())
        .disabled(isCorrectAnswerAnimate != nil)
    }
    
    private var positiveButtonView: some View {
        Button {
            answerHandler(mockQuizData[currentIndex].correctAnswer)
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
    func backUpStatistic() {
        currentStat.setDate(Date().dateTimeString)
        statistic.append(currentStat)
    }
    
    func answerHandler(_ isCorrentAnswer: Bool) {
        isCorrentAnswer ? currentStat.incrementCorrectAnswers() : nil
        
        withAnimation(.easeInOut(duration: 0.15)){
            isCorrectAnswerAnimate = isCorrentAnswer
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isCorrectAnswerAnimate = nil
                
                if currentIndex == 9 {
                    backUpStatistic()
                    alertIsPresented = true
                } else {
                    currentIndex += 1
                }
            }
        }
    }
}

// MARK: - global mock data
let mockQuizData: [QuizQuestionModel] = [
    
    .init(
        image: .theGodfather,
        question: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true
    ),
    .init(
        image: .theDarkKnight,
        question: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true
    ),
    .init(
        image: .killBill,
        question: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true
    ),
    .init(
        image: .theAvengers,
        question: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true
    ),
    .init(
        image: .deadpool,
        question: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true
    ),
    .init(
        image: .theGreenKnight,
        question: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true
    ),
    .init(
        image: .old,
        question: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false
    ),
    .init(
        image: .theIceAgeAdventuresOfBuckWild,
        question: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false
    ),
    .init(
        image: .tesla,
        question: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false
    ),
    .init(
        image: .vivarium,
        question: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false
    ),
    
]

#Preview {
    ContentView()
}
