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
        ZStack {
            switch state {
            case .idle, .loading:
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient.primary.opacity(0.15))
                            .frame(width: 100, height: 100)
                            .blur(radius: 20)

                        Image(systemName: "hourglass")
                            .font(.system(size: 50))
                            .foregroundStyle(LinearGradient.primary)
                            .symbolEffect(.variableColor.iterative.reversing)
                    }

                    VStack(spacing: 8) {
                        Text("takt_loading_title")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("takt_loading_desc")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .transition(.scale(scale: 0.9).combined(with: .opacity))

            case .loaded:
                listView
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .scale(scale: 1.1).combined(with: .opacity)
                    ))

            case .error:
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color("Warning").opacity(0.15))
                            .frame(width: 100, height: 100)
                            .blur(radius: 20)

                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(Color("Warning"))
                            .symbolEffect(.bounce)
                    }

                    VStack(spacing: 8) {
                        Text("takt_error_title")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("takt_error_desc")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: state)
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
        NavigationStack { HabitListView() }
            .appBackground()
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
