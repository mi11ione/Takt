// Widget scaffold – target to be added in a separate PR.
import SwiftUI

struct HabitWidgetPlaceholderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "bolt")
                .imageScale(.large)
            Text("Widget Placeholder")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.quaternary)
    }
}

#Preview { HabitWidgetPlaceholderView() }
