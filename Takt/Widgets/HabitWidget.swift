// Shared small widget tile used by several widget families.
import SwiftUI

struct HabitWidgetView: View {
    let title: LocalizedStringKey
    let emoji: String

    var body: some View {
        VStack(spacing: 6) {
            Text(emoji).font(.system(size: 28))
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color("OnSurfacePrimary"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Card"))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("Border"), lineWidth: 1))
        .clipShape(.rect(cornerRadius: 12))
        .padding(6)
    }
}

#Preview { HabitWidgetView(title: "widget_favorite_placeholder", emoji: "💧") }
