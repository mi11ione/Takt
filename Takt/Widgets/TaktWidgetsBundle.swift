// Widget bundle entry point – set target membership to Widget Extension only.
import WidgetKit
import SwiftUI

@main
struct TaktWidgets: WidgetBundle {
    var body: some Widget {
        QuickStartWidget()
        FavoritesGridWidget()
        TodaySummaryWidget()
        ChainProgressWidget()
        StreakBadgeWidget()
        HabitLiveActivityWidget()
    }
}


