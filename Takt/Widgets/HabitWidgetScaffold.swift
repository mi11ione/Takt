// Shared widget views and entries (used by the real Widget Extension target).
import SwiftUI

struct HabitWidgetPlaceholderView: View {
    var body: some View {
        HabitWidgetView(title: "widget_favorite_placeholder", emoji: "✨")
    }
}

struct StreakBadgeView: View {
    let emoji: String
    let streakDays: Int
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("Card"))
                .overlay(Circle().stroke(Color("Border"), lineWidth: 1))
            VStack(spacing: 2) {
                Text(emoji).font(.system(size: 16))
                Text("\(streakDays)")
                    .font(.caption2).bold()
                    .foregroundStyle(Color("OnSurfacePrimary"))
            }
        }
        .padding(4)
    }
}

#Preview {
    VStack(spacing: 12) {
        HabitWidgetPlaceholderView()
        StreakBadgeView(emoji: "🧘", streakDays: 7)
            .frame(width: 64, height: 64)
    }
    .padding()
    .background(Color("Surface"))
}
