import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color("Surface"), Color("Surface").opacity(0.95), Color.accentColor.opacity(0.08)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

extension View {
    func appBackground() -> some View { background(AppBackground()) }
}


