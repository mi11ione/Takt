import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var isCompact: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(isCompact ? .subheadline : .body)
            .fontWeight(.semibold)
            .padding(.horizontal, isCompact ? 16 : 24)
            .padding(.vertical, isCompact ? 10 : 14)
            .background(LinearGradient.primary)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .shadow(color: Color("PrimaryColor").opacity(0.3), radius: configuration.isPressed ? 4 : 12, y: configuration.isPressed ? 2 : 6)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .medium), trigger: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    var isCompact: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(isCompact ? .subheadline : .body)
            .fontWeight(.medium)
            .padding(.horizontal, isCompact ? 14 : 20)
            .padding(.vertical, isCompact ? 8 : 12)
            .background(.ultraThinMaterial)
            .background(LinearGradient.subtle.opacity(0.3))
            .overlay(
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .clipShape(Capsule())
            .shadow(color: Color("PrimaryColor").opacity(0.1), radius: 8, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed)
    }
}

// Icon Button Style
struct IconButtonStyle: ButtonStyle {
    var size: CGFloat = 44
    var backgroundColor: Color = .init("Primary")

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: size * 0.45))
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(LinearGradient(
                        colors: [backgroundColor, backgroundColor.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            )
            .foregroundStyle(.white)
            .shadow(color: backgroundColor.opacity(0.3), radius: configuration.isPressed ? 2 : 8, y: configuration.isPressed ? 1 : 4)
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed)
    }
}
