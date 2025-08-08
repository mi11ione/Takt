//
//  ContentView.swift
//  Takt
//
//  Created by mi11ion on 8/8/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }

    @Environment(\.networkClient) private var network
    @Environment(\.subscriptionManager) private var subscriptions
    @Environment(\.analytics) private var analytics

    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false
    @State private var state: ViewState = .idle
    @State private var showPaywall: Bool = false

    @Query(sort: [SortDescriptor(\Habit.createdAt, order: .reverse)])
    private var habits: [Habit]

    var body: some View {
        Group {
            switch state {
            case .idle, .loading:
                ContentUnavailableView(
                    "takt_loading_title",
                    systemImage: "hourglass",
                    description: Text("takt_loading_desc")
                )
            case .loaded:
                listView
            case .error:
                ContentUnavailableView(
                    "takt_error_title",
                    systemImage: "exclamationmark.triangle",
                    description: Text("takt_error_desc")
                )
            }
        }
        .navigationTitle(Text("takt_title"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showPaywall = true
                } label: {
                    Label("takt_paywall", systemImage: "crown")
                }
                .buttonStyle(HapticButtonStyle())
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape")
                }
                .accessibilityLabel(Text("takt_settings"))
            }
        }
        .task(id: state) {
            guard state == .idle else { return }
            state = .loading
            await load()
        }
        .fullScreenCover(isPresented: Binding(get: { !hasOnboarded }, set: { _ in })) { OnboardingIntroView() }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    private var listView: some View {
        Group {
            if habits.isEmpty {
                ContentUnavailableView {
                    Label("takt_empty_title", systemImage: "sparkles")
                } description: {
                    Text("takt_empty_desc")
                } actions: {
                    NavigationLink("takt_go_to_library", destination: SettingsView())
                        .buttonStyle(HapticButtonStyle())
                }
            } else {
                List(habits, id: \.id) { habit in
                    HStack(spacing: 12) {
                        Text(habit.emoji)
                        VStack(alignment: .leading) {
                            Text(habit.name)
                                .font(.headline)
                            Text(habit.createdAt, style: .date)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: habit.isFavorite ? "star.fill" : "star")
                            .foregroundStyle(habit.isFavorite ? .yellow : .secondary)
                    }
                    .accessibilityElement(children: .combine)
                }
                .listStyle(.insetGrouped)
            }
        }
    }

    private func load() async {
        analytics.log(event: "app_loaded", nil)
        try? await Task.sleep(nanoseconds: 150_000_000)
        state = .loaded
    }
}

#Preview {
    NavigationStack { ContentView() }
}
