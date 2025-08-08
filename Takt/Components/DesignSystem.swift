import SwiftUI
internal import Combine

// MARK: - Colors & Gradients

extension LinearGradient {
    static let primary = LinearGradient(
        colors: [Color("GradientStart"), Color("GradientEnd")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let subtle = LinearGradient(
        colors: [Color("PrimaryColor").opacity(0.08), Color("SecondaryColor").opacity(0.06)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let mesh = LinearGradient(
        colors: [
            Color("PrimaryColor").opacity(0.15),
            Color("SecondaryColor").opacity(0.12),
            Color("GradientStart").opacity(0.08),
            Color("GradientEnd").opacity(0.10),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let success = LinearGradient(
        colors: [Color("Success"), Color("Success").opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let warning = LinearGradient(
        colors: [Color("Warning"), Color("Warning").opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Glass Effect

struct GlassEffect: ViewModifier {
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(LinearGradient.subtle.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
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
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color("PrimaryColor").opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

extension View {
    func glassEffect(cornerRadius: CGFloat = 16) -> some View {
        modifier(GlassEffect(cornerRadius: cornerRadius))
    }
}

// MARK: - Modern Card Style

struct ModernCard<Content: View>: View {
    let content: Content
    var gradient: LinearGradient = .subtle
    var cornerRadius: CGFloat = 20

    init(gradient: LinearGradient = .subtle, cornerRadius: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.gradient = gradient
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background(.thinMaterial)
            .background(gradient.opacity(0.14))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.05),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color("PrimaryColor").opacity(0.08), radius: 8, x: 0, y: 3)
    }
}

// MARK: - Floating Action Button

struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    @State private var isPressed = false
    @State private var isAnimating = false

    var body: some View {
        Button(action: {
            action()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isAnimating.toggle()
            }
        }) {
            ZStack {
                Circle()
                    .fill(LinearGradient.primary)
                    .frame(width: 56, height: 56)
                    .scaleEffect(isPressed ? 0.9 : 1)
                    .shadow(color: Color("PrimaryColor").opacity(0.22), radius: isPressed ? 6 : 10, y: isPressed ? 3 : 5)

                Image(systemName: icon)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(isAnimating ? 90 : 0))
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity) {} onPressingChanged: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = pressing
            }
        }
    }
}

// MARK: - Animated Background

struct AnimatedMeshBackground: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [Color("Surface"), Color("Surface").opacity(0.95)],
                startPoint: .top,
                endPoint: .bottom
            )

            // Animated blobs
            ForEach(0 ..< 3) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                index == 0 ? Color("PrimaryColor").opacity(0.12) :
                                    index == 1 ? Color("SecondaryColor").opacity(0.12) :
                                    Color("GradientEnd").opacity(0.12),
                                Color.clear,
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .frame(width: 280, height: 280)
                    .blur(radius: 40)
                    .offset(
                        x: animate ? CGFloat.random(in: -60 ... 60) : CGFloat.random(in: -30 ... 30),
                        y: animate ? CGFloat.random(in: -60 ... 60) : CGFloat.random(in: -30 ... 30)
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 8 ... 12))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                        value: animate
                    )
            }

            // Noise texture overlay
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.2)
        }
        .ignoresSafeArea()
        .onAppear { animate = true }
    }
}

// MARK: - Shimmer Effect

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.3),
                        Color.white.opacity(0),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase * 400 - 200)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(Shimmer())
    }
}

// MARK: - Bouncy Button Style

struct BouncyButtonStyle: ButtonStyle {
    var gradient: LinearGradient = .primary

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(gradient)
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            .clipShape(Capsule())
            .shadow(color: Color("PrimaryColor").opacity(0.18), radius: configuration.isPressed ? 3 : 8, y: configuration.isPressed ? 1 : 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .medium), trigger: configuration.isPressed)
    }
}

// MARK: - Glass Button Style

struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .background(LinearGradient.subtle.opacity(0.18))
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
            .shadow(color: Color("PrimaryColor").opacity(0.07), radius: 6, y: 3)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed)
    }
}

// MARK: - Spring Transitions

extension AnyTransition {
    static var springIn: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.8).combined(with: .opacity),
            removal: .scale(scale: 1.1).combined(with: .opacity)
        )
    }

    static var slideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }

    static var bounce: AnyTransition {
        .modifier(
            active: BounceModifier(amount: 1.2),
            identity: BounceModifier(amount: 1)
        )
    }
}

struct BounceModifier: ViewModifier {
    let amount: CGFloat

    func body(content: Content) -> some View {
        content.scaleEffect(amount)
    }
}

// MARK: - Particle Effect

struct ParticleEffect: View {
    @State private var particles: [Particle] = []
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .onReceive(timer) { _ in
            updateParticles()
        }
        .onAppear {
            createParticles()
        }
    }

    func createParticles() {
        for _ in 0 ..< 20 {
            particles.append(Particle())
        }
    }

    func updateParticles() {
        for i in particles.indices {
            particles[i].update()
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var color: Color
    var size: CGFloat
    var opacity: Double

    init() {
        position = CGPoint(
            x: CGFloat.random(in: 0 ... UIScreen.main.bounds.width),
            y: UIScreen.main.bounds.height + 50
        )
        velocity = CGVector(
            dx: CGFloat.random(in: -2 ... 2),
            dy: CGFloat.random(in: -5 ... -2)
        )
        color = [Color("PrimaryColor"), Color("SecondaryColor"), Color("GradientStart")].randomElement()!
        size = CGFloat.random(in: 4 ... 8)
        opacity = Double.random(in: 0.6 ... 1)
    }

    mutating func update() {
        position.x += velocity.dx
        position.y += velocity.dy
        opacity -= 0.02

        if position.y < -50 || opacity <= 0 {
            position = CGPoint(
                x: CGFloat.random(in: 0 ... UIScreen.main.bounds.width),
                y: UIScreen.main.bounds.height + 50
            )
            opacity = Double.random(in: 0.6 ... 1)
        }
    }
}
