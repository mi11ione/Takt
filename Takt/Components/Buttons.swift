import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.accentColor, in: .capsule)
            .foregroundStyle(.white)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.snappy, value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .medium), trigger: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.thinMaterial, in: .capsule)
            .foregroundStyle(.primary)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.snappy, value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed)
    }
}


