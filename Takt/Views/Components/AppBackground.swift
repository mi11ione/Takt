import SwiftUI

struct AppBackground: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    Color("Surface"),
                    Color("Surface").opacity(0.97),
                    Color("PrimaryColor").opacity(0.03),
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Animated gradient blobs
            ForEach(0 ..< 3) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                index == 0 ? Color("PrimaryColor").opacity(0.15) :
                                    index == 1 ? Color("SecondaryColor").opacity(0.12) :
                                    Color("GradientEnd").opacity(0.10),
                                Color.clear,
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 200
                        )
                    )
                    .frame(width: 360, height: 360)
                    .blur(radius: 60)
                    .offset(
                        x: animate ?
                            (index == 0 ? -100 : index == 1 ? 100 : 0) :
                            (index == 0 ? 100 : index == 1 ? -100 : 50),
                        y: animate ?
                            (index == 0 ? -200 : index == 1 ? 200 : 0) :
                            (index == 0 ? 200 : index == 1 ? -200 : -100)
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 12 ... 18))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                        value: animate
                    )
            }

            // Mesh gradient overlay
            Rectangle()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color("GradientStart").opacity(0.02), location: 0),
                            .init(color: Color.clear, location: 0.35),
                            .init(color: Color("GradientEnd").opacity(0.02), location: 0.7),
                            .init(color: Color.clear, location: 1),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .rotationEffect(.degrees(animate ? 5 : -5))
                .animation(
                    .easeInOut(duration: 28)
                        .repeatForever(autoreverses: true),
                    value: animate
                )

            // Subtle noise texture
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.04)
        }
        .ignoresSafeArea()
        .onAppear { animate = true }
    }
}

extension View {
    func appBackground() -> some View {
        background(AppBackground())
    }

    func animatedBackground() -> some View {
        background(AnimatedMeshBackground())
    }
}
