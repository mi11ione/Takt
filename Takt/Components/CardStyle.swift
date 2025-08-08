import SwiftUI

struct Card<Content: View>: View {
    let content: Content
    var style: CardStyle = .elevated

    enum CardStyle {
        case elevated
        case glass
        case gradient
        case flat
    }

    init(style: CardStyle = .elevated, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }

    var body: some View {
        content
            .padding(14)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(overlayView)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
            .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .elevated:
            RoundedRectangle(cornerRadius: 20)
                .fill(.thinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient.subtle.opacity(0.14))
                )
        case .glass:
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient.mesh.opacity(0.10))
                )
        case .gradient:
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient.primary.opacity(0.12))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("Surface"))
                )
        case .flat:
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("Card"))
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        if style == .glass || style == .elevated {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("Border"), lineWidth: 1)
        }
    }

    private var shadowColor: Color {
        switch style {
        case .elevated, .glass:
            Color("PrimaryColor").opacity(0.08)
        case .gradient:
            Color("PrimaryColor").opacity(0.12)
        case .flat:
            Color("OnSurfacePrimary").opacity(0.05)
        }
    }

    private var shadowRadius: CGFloat {
        switch style {
        case .elevated:
            8
        case .glass:
            7
        case .gradient:
            10
        case .flat:
            3
        }
    }

    private var shadowY: CGFloat {
        switch style {
        case .elevated, .glass:
            3
        case .gradient:
            4
        case .flat:
            1
        }
    }
}

// Interactive Card
struct InteractiveCard<Content: View>: View {
    let content: Content
    let action: () -> Void
    @State private var isPressed = false

    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }

    var body: some View {
        Button(action: action) {
            Card(style: .elevated) {
                content
                    .foregroundStyle(.primary)
            }
        }
        .buttonStyle(InteractiveCardButtonStyle())
    }
}

struct InteractiveCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed)
    }
}
