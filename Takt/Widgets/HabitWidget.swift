// Widget scaffold to be moved into a Widget Extension in a later PR.
import SwiftUI

struct HabitWidgetView: View {
    let title: LocalizedStringKey
    let emoji: String

    var body: some View {
        VStack(spacing: 6) {
            Text(emoji).font(.system(size: 28))
            Text(title).font(.caption).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 12))
        .padding(6)
    }
}

#Preview { HabitWidgetView(title: "widget_favorite_placeholder", emoji: "💧") }
