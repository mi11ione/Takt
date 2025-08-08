//
//  ContentView.swift
//  Takt
//
//  Created by mi11ion on 8/8/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    enum ViewState: Equatable { case loaded }

    @Environment(\.networkClient) private var network
    @Environment(\.subscriptionManager) private var subscriptions
    @Environment(\.analytics) private var analytics

    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false
    @State private var state: ViewState = .loaded
    @State private var showPaywall: Bool = false

    @Query(sort: [SortDescriptor(\Habit.createdAt, order: .reverse)])
    private var habits: [Habit]

    var body: some View {
        listView
        .navigationTitle(Text("takt_title"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showPaywall = true
                } label: {
                    Image(systemName: "crown.fill")
                        .font(.subheadline)
                        .foregroundStyle(LinearGradient.primary)
                }
                .sensoryFeedback(.impact(weight: .light), trigger: showPaywall)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.subheadline)
                        .foregroundStyle(Color("PrimaryColor"))
                }
                .accessibilityLabel(Text("takt_settings"))
            }
        }
        .task {} // no-op; keep structure
        .fullScreenCover(isPresented: Binding(get: { !hasOnboarded }, set: { _ in })) { OnboardingIntroView() }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    private var listView: some View {
        NavigationStack { HabitListView() }
            .appBackground()
    }

    private func load() async {}
}

#Preview {
    NavigationStack { ContentView() }
}
