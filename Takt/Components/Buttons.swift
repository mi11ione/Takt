import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    var isCompact: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(isCompact ? .subheadline : .body)
            .fontWeight(.medium)
            .padding(.horizontal, isCompact ? 12 : 18)
            .padding(.vertical, isCompact ? 7 : 10)
            .background(.thinMaterial)
            .background(LinearGradient.subtle.opacity(0.18))
            .overlay(
                Capsule()
                    .stroke(Color("Border"), lineWidth: 1)
            )
            .clipShape(Capsule())
            .shadow(color: Color("PrimaryColor").opacity(0.07), radius: 6, y: 3)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed)
    }
}

// Icon Button Style
struct IconButtonStyle: ButtonStyle {
    var size: CGFloat = 44
    var backgroundColor: Color = .init("PrimaryColor")

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
            .foregroundStyle(Color("OnEmphasis"))
            .shadow(color: backgroundColor.opacity(0.18), radius: configuration.isPressed ? 2 : 6, y: configuration.isPressed ? 1 : 3)
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed)
    }
}
