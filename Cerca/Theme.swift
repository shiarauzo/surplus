import SwiftUI

enum Theme {
    static let gray = Color(red: 0.773, green: 0.773, blue: 0.796)
    static let name = Color(red: 0.780, green: 0.780, blue: 0.780)
    static let pin = Color(red: 0.937, green: 0.239, blue: 0.051)
    static let blue = Color(red: 0.282, green: 0.490, blue: 0.980)
    static let pass = Color(red: 0.855, green: 0.616, blue: 0.616)
    static let link = Color(red: 0.071, green: 0.204, blue: 0.875)
}

struct PressedScale: ButtonStyle {
    var resting: CGFloat = 1

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? resting * 0.97 : resting)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}
