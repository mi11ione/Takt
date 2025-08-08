import ActivityKit

// Live Activity scaffold to be moved into an ActivityKit target later.
import SwiftUI

struct HabitTimerView: View {
    let title: String
    let progress: Double

    var body: some View {
        HStack {
            ProgressView(value: progress)
            Text(title)
                .font(.caption)
        }
        .padding(8)
    }
}

#Preview { HabitTimerView(title: "Focus Reset", progress: 0.5) }
