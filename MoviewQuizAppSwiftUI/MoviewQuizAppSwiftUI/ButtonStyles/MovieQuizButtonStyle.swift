import SwiftUI

struct MovieQuizButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .foregroundStyle(.ysBlack)
                .padding()
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ysWhite)
        }
        .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
