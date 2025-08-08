import SwiftUI

/// A reusable button style that adds subtle haptics and scale animation.
public struct HapticButtonStyle: ButtonStyle {
    public init(feedback: SensoryFeedback = .impact(weight: .medium)) {
        self.feedback = feedback
    }

    private let feedback: SensoryFeedback

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.snappy, value: configuration.isPressed)
            .sensoryFeedback(feedback, trigger: configuration.isPressed)
    }
}
