import SwiftData
import SwiftUI

struct WeeklyInsightsView: View {
    @Query private var entries: [HabitEntry]

    var body: some View {
        List {
            Section(header: Text("insights_header")) {
                summaryText()
            }
        }
        .navigationTitle(Text("insights_title"))
    }

    private func summaryText() -> Text {
        let count = entries.filter { Calendar.autoupdatingCurrent.isDate($0.performedAt, equalTo: .now, toGranularity: .weekOfYear) }.count
        if count == 0 { return Text("insights_weekly_zero") }
        if count == 1 { return Text("insights_weekly_one") }
        return Text(String(format: NSLocalizedString("insights_weekly_multi", comment: ""), count))
    }
}

#Preview { WeeklyInsightsView() }
