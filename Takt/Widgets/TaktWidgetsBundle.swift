import SwiftUI

// Widget bundle entry point – set target membership to Widget Extension only.
import WidgetKit

@main
struct TaktWidgets: WidgetBundle {
    var body: some Widget {
        // Skeleton only: keep the Live Activity configuration available.
        HabitLiveActivityWidget()
    }
}
