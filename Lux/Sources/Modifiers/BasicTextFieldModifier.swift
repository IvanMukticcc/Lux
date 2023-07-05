import SwiftUI

enum InputStyle: String {
    case description = "Description"
}

struct BasicTextFieldModifier: ViewModifier {
    var inputStyle: InputStyle

    func body(content: Content) -> some View {
        HStack {
            Text(inputStyle.rawValue)
            Spacer()
            content
                .multilineTextAlignment(.trailing)
                .foregroundColor(.gray)
        }
    }
}

extension TextField {
    func inputStyle(_ style: InputStyle) -> some View {
        modifier(BasicTextFieldModifier(inputStyle: style))
    }
}
