## Takt Product Roadmap (Feature, Documentation, and Functionality Focus)

This document lays out a comprehensive, end‑to‑end plan to evolve Takt from today’s base to a category‑leading micro‑habit app. It focuses on features, functionality, UX flows, content/copy, growth, documentation, and operational readiness (non‑technical). It also defines acceptance criteria, success metrics, and a staged delivery plan.

---

### Vision
- **What**: Ultra‑fast micro‑habits delivered as tiny, instantly completable actions with rich haptics and delightful feedback.
- **Why**: Planning fatigue kills habit momentum. People need a frictionless, satisfying way to execute tiny actions consistently.
- **Where**: Lock Screen, widgets, Apple Watch, quick App Shortcuts, and light in‑app flows.

### Personas
- **Focus‑strapped Pro**: Knowledge worker with fragmented day. Wants quick resets (60–90s) between meetings.
- **Neurodiverse Student**: Needs a nudge to get started; thrives with short, rewarding loops and tactile confirmations.
- **Wellness Minimalist**: Wants simple streaks that avoid heavy tracking or complex goal setup.

### Jobs‑To‑Be‑Done
- Insert 30–90s routines into tiny gaps throughout the day.
- Maintain momentum with streaks/chains and gentle accountability.
- Feel accomplishment without heavy configuration or data entry.

---

## Experience Principles
- **Tap and done**: Every core action is completable in ≤ 2 taps.
- **Tactile joy**: Satisfying haptics and micro‑animations reinforce progress.
- **Structured lightness**: Optional structure (chains, templates) never adds friction by default.
- **Positive defaults**: Encouraging, non‑judgmental copy. No shaming.
- **Respect attention**: Minimal notifications; clear controls; Focus‑aware.

---

## Current Status Snapshot
- Phase A — COMPLETE: Habit library (create/edit/archive/favorites), one‑tap log, streaks, weekly insights (text), starter templates, toolbar navigation, A/B post‑3‑logs paywall, localization copy.
- Phase B — COMPLETE: Chains (model + editor + list), run chain (step‑by‑step), navigation entry, full strings.
- Nudges — BASELINE IMPLEMENTED: Daypart suggestions (morning/midday/afternoon/evening) via Settings notifications toggle; opt‑in authorization.

## Feature Themes (Overview)
- Micro‑Habit Library & Builder
- Streaks & Chains
- Focus‑Aware Triggers & Scheduling
- Micro‑Timer & Haptic Feedback
- Widgets & Lock Screen Surfaces
- Live Activities (micro‑timer)
- Apple Watch (future)
- Notifications (gentle nudges)
- Insights (weekly), Share Cards, and Exports (Pro)
- Templates & Coach Packs (Pro)
- Sync (iCloud), Collaboration/Teams (Premium tiers, later)
- Monetization (annual‑first), Paywall & Offers
- App Shortcuts (quick actions)
- Settings, Help, and Support
- Growth & Distribution

---

## Detailed Feature Specifications

### 1) Micro‑Habit Library & Builder
- **Capabilities**
  - Create habits with: name, emoji, optional short description, optional tag(s), expected time (30/60/90s), and optional “motivation” line.
  - Categorize (Focus, Study, Energy, Wellness, Admin, Reset).
  - Mark favorites for surfaces (widgets/shortcuts).
  - Quick log: single tap to record an instance; optional timer (see Micro‑Timer).
  - Edit/Archive: rename, change emoji, tags, or archive to hide; unarchive later.
- **User stories**
  - “As a user, I want to add a ‘90‑second desk stretch’ habit so I can do it after long calls.”
  - “As a user, I want to quickly mark a habit done in one tap.”
- **Acceptance criteria**
  - Add habit requires ≤ 2 screens; save in ≤ 2 taps.
  - Quick log completes in ≤ 2 taps, shows immediate tactile feedback.
  - Empty state educates and nudges to add first 1–3 habits.
- **Copy examples**
  - Empty: “Start with one tiny action. We’ll keep it simple.”
  - New habit placeholder: “Name (short and snappy)”, “Add an emoji”, “Optional: why this matters to you.”

### 2) Streaks & Chains
- **Streaks**
  - Daily streak per habit with chain continuity visual.
  - Edge cases: time zones, travel days, late‑night logs (grace window), missed days.
  - Gentle recovery: “Pick it back up today — every streak has a first day.”
- **Chains**
  - Build small sequences (2–5 habits) that flow naturally.
  - One‑tap “Start Chain” to log as you advance; chain progress view; “chain depth” (how long the chain lasted historically).
- **User stories**
  - “As a user, I want a short chain for morning focus: water → desk stretch → inbox zero (5min).”
  - “As a user, I want streaks to motivate me without pressure when I miss a day.”
- **Acceptance criteria**
  - Streak UI is understandable at a glance; chain progression never confuses order.
  - Grace window settings are clear (e.g., optional: count late‑night log toward intended day).
  - Never shame; always encourage.
- **Copy examples**
  - Chain complete: “Chain complete. That momentum is real.”
  - Streak break: “New day, new streak. You’ve got this.”

### 3) Focus‑Aware Triggers & Scheduling
- **Capabilities**
  - Daypart suggestions (morning, midday, afternoon, evening) tailored to user patterns.
  - Focus mode relevance (Work/Study/Fitness) to surface the right habits/chains.
  - Simple schedule hints: “Most days at 9am” — not a rigid schedule.
- **User stories**
  - “As a user, I want Takt to suggest a quick reset when I switch to Work Focus.”
  - “As a user, I want a gentle nudge in the evening to do my 60‑second stretch.”
- **Acceptance criteria**
  - Suggestions feel helpful, not spammy; easy to mute or adjust.
  - Clear controls in Settings for preferences and quiet hours.
- **Copy examples**
  - Suggestion: “Quick reset? 60s stretch now can feel great.”

### 4) Micro‑Timer & Haptic Feedback
- **Capabilities**
  - 30/60/90s preset timer with delightful haptic start/finish.
  - Inline progress indicator; pause/cancel.
  - Optional timer skip for true one‑tap logging.
- **User stories**
  - “As a user, I want a 60s timer with satisfying completion feedback.”
- **Acceptance criteria**
  - Timer never blocks other navigation; tactile feedback is subtle and pleasant.
  - Works well in widgets/live activities (see below).
- **Copy examples**
  - Completion: “Done. Small wins add up.”

### 5) Widgets & Lock Screen Surfaces
- **Capabilities**
  - Small/medium/large widgets showing favorite habit, streaks, or chain progress.
  - Multiple tap targets: quick log, open chain, open insights.
  - Lock Screen glance: streak day count, next habit suggestion.
- **User stories**
  - “As a user, I want to log my favorite habit from the Lock Screen.”
- **Acceptance criteria**
  - Interaction is clear and reliable; placeholders informative for empty states.
- **Copy examples**
  - Placeholder: “Pick a favorite habit for quick logging.”

### 6) Live Activities (Micro‑Timer)
- **Capabilities**
  - Live micro‑timer in Dynamic Island/Lock Screen.
  - Quick actions: pause/cancel/complete.
- **User stories**
  - “As a user, I want to start a 90‑second focus reset and see it on my Lock Screen.”
- **Acceptance criteria**
  - Reads clearly at a glance; no accidental cancels; completion feels rewarding.

### 7) Apple Watch (Future)
- **Capabilities**
  - Ultra‑fast log from complication; wrist haptics; micro‑timer.
  - Quick chain start from a favorite complication.
- **User stories**
  - “As a user, I want to tap my watch to log a quick breathe/stretch anywhere.”
- **Acceptance criteria**
  - One‑tap flows, non‑intrusive haptics; great with Raise to Wake.

### 8) Notifications (Gentle Nudges)
- **Templates**
  - Daypart: “Afternoon reset? 60s stretch feels great.”
  - Streak save: “You’re close to saving today’s streak. One tiny action.”
  - Chain nudge: “Continue your chain? Inbox zero next.”
- **Policies**
  - Frequency caps; quiet hours; easy mute/dismiss.
  - Personalization based on behavior; stop if ignored repeatedly.
- **User stories**
  - “As a user, I want helpful reminders that don’t nag me.”
- **Acceptance criteria**
  - Clear settings control; opt‑in at onboarding with context; respectful defaults.

### 9) Insights (Weekly), Share Cards, Exports (Pro)
- **Insights**
  - “Most consistent time of day,” “Longest streak,” “Chain depth trend,” “Week over week micro‑dose count.”
  - Small, meaningful visuals, not dashboards.
- **Share Cards**
  - Beautiful graphics for streaks/chains; export as images to share.
- **Exports (Pro)**
  - CSV/JSON export with basic fields: date/time, habit name, duration, chain membership.
- **User stories**
  - “As a user, I want a weekly summary that motivates me.”
  - “As a Pro user, I want to export my data.”
- **Acceptance criteria**
  - Insight copy is plain and encouraging; exports are accurate and simple.

### 10) Templates & Coach Packs (Pro)
- **Templates**
  - Starter set: Focus Reset (water, stretch, inbox skim), Desk Wellness, Study Sprint, Evening Wind‑Down.
  - Coach “Packs”: themed bundles (ADHD Focus, Exam Prep, Deep Work Warm‑ups).
- **User stories**
  - “As a user, I want to quickly add best‑practice micro‑habits without thinking.”
- **Acceptance criteria**
  - Add from template ≤ 2 taps; clear descriptions; optional customization.

### 11) Sync (iCloud), Collaboration/Teams (Later/Premium)
- **Sync**
  - Optional iCloud switch in Settings; clear privacy language.
- **Collaboration**
  - Share chain template; later: Team mode with simple roles.
- **User stories**
  - “As a user, I want my habits on my iPhone and iPad without extra setup.”
- **Acceptance criteria**
  - Opt‑in only; privacy‑preserving defaults; clear status messaging.

### 12) App Shortcuts (Quick Actions)
- **Catalog**
  - Log Habit (no/with name parameter), Open Streaks, Start Chain, Mark Favorite.
- **User stories**
  - “As a user, I want to say ‘Hey Siri, log water’ and be done.”
- **Acceptance criteria**
  - Phrases feel natural; discovery via Shortcuts app; clear names.

### 13) Settings, Help, and Support
- **Settings**
  - Subscription management, restore. Preferences: notifications, iCloud sync, haptics intensity.
  - Legal: privacy, terms. About: version, acknowledgements.
- **Help**
  - Quick answers: “How streaks work,” “What’s a chain,” “How to customize templates,” “How to export data.”
  - In‑app tips (3–5) at first‑use moments; dismissible.
- **Support**
  - Mailto link with prefilled diagnostics (locale, app version), optional screenshot instructions.
- **Acceptance criteria**
  - Users can self‑serve most questions within 2 taps; support path is obvious and friendly.

---

## Onboarding & Journeys

### First‑Run (≤ 3 screens)
1) Promise & Value: “Micro‑habits that actually stick.”
2) Personalization (optional): pick 1–3 starter habits (or “I’ll do this later”).
3) Paywall variant (A/B): annual‑first, no trial; or defer paywall until 3 logs.

### Day‑1 Journey
- Add first habit, log once, feel success (haptic + copy).
- Suggest widget or Lock Screen quick add.

### Day‑7 Journey
- Weekly insight card; celebrate streaks/chains; subtle upsell for Pro.

### Recovery Journey (after break)
- Encouraging copy; avoid guilt; show chain depth metric improving again.

### Cancellation & Win‑Back (Pro)
- Simple cancel flow with optional 1‑question reason; future win‑back offer after cooling period.

---

## Monetization (Annual‑First; No Trial)
- **Pricing**: $4.99/mo or $24.99/yr (≈35% discount). Annual default.
- **Gating**
  - Free: Core habits, limited insights, templates preview, daily usage cap (3–5 logs/day) or post‑3 logs soft paywall.
  - Pro: Unlimited logs, weekly insights, templates/packs, export, future sync.
  - Premium (later): Teams, SharePlay sessions, advanced content packs.
- **Upsell Triggers**
  - After 3 logs/day, when opening Insights, adding a third chain, or installing a template pack.
  - Win‑back: targeted offer after subscription lapse.
- **Paywall Content**
  - Clear benefits list; plain language; price localized; satisfaction guarantee copy tone.

---

## Content & Copy Strategy
- **Voice & Tone**: Friendly, concise, encouraging. Avoid guilt. Celebrate consistency over volume.
- **Microcopy Guidelines**
  - “Small wins add up.” “That was quick — nice work.” “Pick it up again today.”
  - Avoid jargon; keep labels short; prefer verbs.
- **Notifications Tone**: Gentle, suggestive, and easy to opt out; never shaming.
- **Template Descriptions**: 1–2 lines: purpose, when to use, expected feeling.

---

## Documentation & Help
- **In‑App Help Topics**
  - What is a micro‑habit? How do streaks work? What are chains? How to customize a template? How to export? How to manage notifications? How to restore purchases?
- **FAQ (Website/Support)**
  - Privacy stance (no tracking), data export/deletion, subscription questions, refund guidance, device sync.
- **Release Notes Style**
  - Conversational and user‑oriented; highlight quality of life improvements; link to tips.

---

## Growth & Distribution
- **Channels**: TikTok (30‑sec habit series), Product Hunt launch, Reddit communities, micro‑influencers.
- **Share Cards**: Promote streaks; optional watermark; tasteful and private by default.
- **Referral Hooks**: “Gift a template” link (no tracking); QR codes in social content.
- **App Store Optimization**
  - Keywords: micro‑habits, streaks, focus reset, ADHD focus, productivity.
  - Creative narrative: show one‑tap log, chain completion, weekly insight.

---

## KPIs & Success Metrics (Product‑Level)
- Activation: % new users who add ≥1 habit on Day‑0; % who log ≥1 on Day‑0.
- Engagement: Avg logs/day; % using widgets; % using chains.
- Retention: D7, D30; streak sustainers; chain depth median.
- Monetization: Paywall view→start→success rate; monthly vs. annual share; churn rate.
- Notifications: Opt‑in rate; open rate; dismiss/mute rate.

---

## Acceptance Criteria (Product)
- One‑tap log feels instant and rewarding.
- Streaks and chains are obvious and never confusing.
- Notifications are helpful and easy to control.
- Paywall is clear, respectful, and non‑deceptive.
- Weekly insights feel meaningful in 10 seconds or less.
- Settings surface the right controls without overwhelm.

---

## Experiments Backlog (A/B/C)
- Paywall timing: post‑onboarding vs. after 3 logs.
- Copy variants: “Unlock Pro” vs. “Go Pro”; social proof line vs. none.
- Widget defaults: favorite habit vs. “smart” suggestion.
- Streak grace window defaults: strict vs. forgiving.
- Notification cadence: daypart suggestions vs. behavior‑driven.

---

## Release Plan (Non‑Technical Deliverables)
- Screenshots storyboard: one‑tap log, chain progress, weekly insight, widget, paywall.
- App preview video script: 15–20s; shows micro‑timer, haptics, chain completion.
- Localized store copy (EN first; ES/DE/FR next waves).
- Press kit: logo, icon, color palette, product summary, privacy stance.
- Support readiness: help topics, contact email template, refund policy guidance.

---

## Risks & Mitigations (Product)
- Superficiality: Add “chain depth” and “weekly insight” to reinforce meaning; optional deep session weekly.
- Notification fatigue: Conservative defaults, caps, and visible controls.
- Over‑feature creep: Stage features; keep defaults minimal; ensure core one‑tap remains central.

---

## Phased Delivery (Feature‑First)

### Phase A (MVP, 2–3 weeks)
- Library (create/edit/archive), quick log, streaks (daily), favorites, onboarding (≤3 screens), paywall baseline, settings basics, 1–2 starter templates, 1–2 widgets (non‑interactive placeholder if needed), weekly insights v0 (text‑only), share cards v0.
- Success: 80%+ of users can add and log on Day‑0; no confusion on streaks.

### Phase B (2–3 weeks)
- Chains (build + run), daypart suggestions, improved notifications, paywall experiments (timing/copy), more templates.
- Success: ≥20% users start a chain; nudges have >5% open rate without spike in mutes.

### Phase C (3–4 weeks)
- Interactive widgets, live micro‑timer, weekly insights v1 (more meaningful), exports (Pro), richer share cards.
- Success: ≥30% widget adoption; weekly insights screens get ≥40% views among actives.

### Phase D (3–5 weeks)
- iPad UX, keyboard shortcuts, packs marketplace (static curated), light sync option (opt‑in), TipKit.
- Success: iPad MAU > 10% of total; template adoption > 25% among new users.

### Phase E (5–8 weeks)
- SharePlay sessions (optional), team mode (behind flag), growth loops (referrals), broader localization, App Store launch hardening.
- Success: Retention uplift; share rate increases; stable ratings ≥ 4.6.

---

## Appendices

### A) Sample Copy Library
- Onboarding headline: “Micro‑habits that actually stick.”
- Paywall headline: “Unlock Pro — small wins, big consistency.”
- Timer complete: “Done. That was quick — nice work.”
- Streak break: “New day, new streak. You’ve got this.”
- Chain complete: “Chain complete. That momentum is real.”
- Empty state: “Start with one tiny action. We’ll keep it simple.”

### B) Notification Templates
- Daypart: “Afternoon reset? 60s stretch feels great.”
- Streak save: “You’re close to saving today’s streak. One tiny action.”
- Chain nudge: “Continue your chain? Inbox zero next.”
- Weekly insight: “You were most consistent at 9am this week.”

### C) Streak Rules (User‑Facing)
- Streaks track daily consistency per habit.
- You can enable a gentle grace window if you often log late.
- Missing a day isn’t failure — pick it back up anytime.

### D) Glossary
- Micro‑habit: A 30–90s action meant to be instantly completable.
- Chain: A small sequence of micro‑habits performed in order.
- Chain depth: The length/intensity of a chain over time.
- Daypart: Morning, Midday, Afternoon, Evening.

## Takt Roadmap

This roadmap lays out the detailed plan from the current scaffold to a production‑ready app with robust functionality, delightful UX, and App Store readiness. It aligns with our engineering rules: SwiftUI‑only, iOS 18+, THE VIEW architecture (no ViewModels), protocol‑oriented services via Environment, Swift Concurrency, SwiftData persistence, StoreKit 2 monetization, OSLog/MetricKit analytics, privacy by design, and no third‑party SDKs.

### Vision & Product Objectives
- **One‑liner**: Ultra-fast micro-habits as Lock Screen/Watch actions with streak chains and satisfying haptics.
- **Jobs-To-Be-Done**: Insert 30–90s routines into gaps; maintain streaks; track micro‑progress; reduce activation friction.
- **Core Differentiators**: Focus on execution (micro‑doses), delightful haptic UX, chain mechanics, Focus‑aware triggers.

## Guiding Principles
- **Swiftness**: Ultra‑low friction; single‑tap flows; instant feedback with `.sensoryFeedback()`.
- **Local‑first**: Process locally; sync optionally via iCloud; retain privacy by design.
- **Predictable architecture**: THE VIEW; explicit state enums; protocol services via `EnvironmentValues`.
- **Performance**: Instruments signposts for key flows; smooth animations; background work via async/await.
- **Accessibility**: Dynamic Type, VoiceOver hints, sufficient contrast, large tap targets, localized content.
- **Observability**: OSLog categories; MetricKit crash/energy; minimal custom analytics via logs.

## Architecture
- **UI**: SwiftUI with `NavigationStack`, modular subviews, `.task(id:)` for cancellable effects.
- **State**: Explicit `ViewState` enums (idle/loading/loaded/error); single source of truth per screen.
- **Services** (protocols via Environment):
  - **NetworkClient**: stateless, `Sendable`, tiny surface. Prefer not to use unless needed.
  - **SubscriptionManaging**: StoreKit 2 purchase/restore/status; entitlement checks; offers handling.
  - **Analytics**: OSLog sink + MetricKit subscriber. No third‑party.
  - (Later) **SyncService**: CloudKit‑backed SwiftData sync configuration.
  - (Later) **NotificationScheduler**: `UNUserNotificationCenter`, Focus awareness, schedule management.
- **Persistence**: SwiftData models with migration plan; default on‑device; optional CloudKit sync.
- **Concurrency**: Async/await only; `Task`, `TaskGroup`, and Actors for shared mutable state (e.g., Sync actor).
- **App Intents**: App Shortcuts for quick actions; widgets use AppIntent for interactivity.
- **Widgets/Live Activities**: WidgetKit + ActivityKit; push update capability (later PRs/targets).

## Design System & Styling
- **Color**: Semantic palette (primary, secondary, background, accent, success, warning). Auto dark mode variants via Assets.xcassets.
- **Typography**: Use SwiftUI text styles; keep dynamic; avoid fixed sizes except display accents.
- **Components**:
  - `HapticButtonStyle` for consistent tactile interactions.
  - `Badge`, `Pill`, `Card`, `ProgressRing` (micro‑timer), `EmptyState` templates.
  - `PaywallCallout`, `FeatureRow`, `SettingRow`.
- **Animation**: Spring/snappy animations; progress timers with `PhaseAnimator`/`TimelineView`.
- **Accessibility**: Labels, traits, focus order; reduce motion support; color contrast verification.

## Data Model & Migrations (SwiftData)
- **V1** (current): `Habit`, `HabitEntry`.
  - `Habit`: id (UUID, unique), name, emoji, createdAt, isFavorite, entries [cascade].
  - `HabitEntry`: id, performedAt, durationSeconds, relationship to `Habit`.
- **V2**: Add `Chain` (ordered list of habits), `streakCount` (derived/cache), `lastPerformedAt` (derived/cache), `archivedAt`.
- **V3**: `Template` and `Pack` entities for coach/template packs; relationship to `Habit`.
- **Migrations**: Favor lightweight automatic where possible. Backfill derived fields on first boot post‑migration with `ModelContext` background tasks.

## Services Expansion
- **SubscriptionManaging**
  - Wire product IDs; subscription group; monthly ($4.99), annual ($24.99), no trial.
  - Implement `purchasePremium()` with StoreKit 2, verification via `Transaction.latest(for:)`.
  - Promotional offers, win‑back offers for lapsed subs; offer code redemption deeplink support.
  - Entitlement gating helpers (e.g., `isProFeatureEnabled`).
- **Analytics**
  - Event taxonomy: app_open, habit_add, habit_log, chain_start, chain_complete, streak_break, paywall_show, purchase_start/success/fail, widget_tap, live_activity_start/stop, notification_delivered/opened.
  - OSLog categories: app, analytics, subscription, performance, widget, live‑activity, networking.
  - MetricKit hooks: crash, hang, energy, memory. Periodic summaries to local store for internal dashboards.
- **NotificationScheduler** (later)
  - Permission request flow during onboarding; nuanced copy.
  - Daypart nudges, streak break reminders, focus‑aware triggers (Focus Filters API).
  - Quiet hours and Do Not Disturb detection.
- **SyncService** (later)
  - CloudKit sync using SwiftData CloudKit configuration; conflict resolution (last‑write wins with user merge prompts for destructive conflicts).

## Feature Roadmap by Phase

### Phase 0 — Foundation (DONE / current)
- App skeleton with SwiftData, services via Environment, onboarding (≤3 screens), settings, paywall baseline, App Shortcuts, scaffolds for widgets/live activities, privacy manifest, localization base.

### Phase 1 — Micro‑Habit Library & Streaks (MVP Core)
- **Library**: Create, edit, delete habits; choose emoji; mark favorite.
- **Logging**: One‑tap log from list cells; default 30–90s micro‑timer; haptic feedback on completion.
- **Streaks**: Per‑habit streak (daily); chain continuity; compute derived metrics on demand; empty states.
- **Onboarding**: Funnel to paywall post‑intro or after 3 logs (A/B bucket via `@AppStorage`).
- **Settings**: Restore purchases; manage subscription; app version; contact; privacy/terms links.
- **Instrumentation**: OSLog events for key actions; MetricKit enablement; signposts around log timer.
- **Acceptance**: Smooth log flow (<500ms perceived), no crashes, all lists accessible, dynamic type friendly.

### Phase 2 — Chains & Focus‑Aware Triggers
- **Chains**: Build small sequences (2–5 habits) with optional gaps; “start chain” single action; chain depth metric.
- **Focus**: Focus Filters to suggest relevant chains/habits in specific modes (Work, Fitness, Study).
- **Notifications**: Gentle nudges per daypart; chain reminders; streak break alerts; in‑app notification center screen.
- **Paywall**: A/B paywall placements (after onboarding vs. 3 uses). Annual‑first copy; localized prices.
- **StoreKit**: Implement purchase flow, entitlement cache, transaction verification; restore/resubscribe flows.
- **Acceptance**: Chain UX is snappy and comprehensible; notifications respect system settings; purchases verified.

### Phase 3 — Widgets & Live Activities
- **Interactive Widgets**: Small/medium/large; quick log; show streak, next habit, chain progress; multiple tap targets.
- **Lock Screen**: Inline actions where possible; Glanceable stats.
- **Live Activities**: 30–90s micro‑timer; compact/expanded; Dynamic Island for in‑progress actions; push updates support.
- **App Intents**: Extend intents for chain start, log favorite, toggle favorite.
- **Acceptance**: Widgets update reliably; live activity animates smoothly; actions feel instantaneous with haptics.

### Phase 4 — iPad Enhancements & Power UX
- **Layout**: Split view/Inspector for habit details and history; keyboard shortcuts (add/log/search/navigate).
- **Drag & Drop**: Reorder chains, drag habits into chains.
- **Data**: Inline charts for weekly micro‑progress with system `Charts`.
- **Acceptance**: iPad experience feels first‑class; keyboard flows efficient; no layout glitches in all sizes.

### Phase 5 — Analytics & Insights (Pro)
- **Insights**: Weekly insights screen; “most consistent time of day”, “chain depth trend”, “micro‑dose velocity”.
- **Exports**: CSV/JSON export (Pro); Share Sheet support; privacy "/ on‑device generation.
- **Share Cards**: Rich sharing of streaks/chains as images using SwiftUI rendering; privacy conscious.
- **Acceptance**: Insight generation completes in <200ms on median device; exports correct; share cards crisp.

### Phase 6 — Templates, Packs, and Coach Content (Pro)
- **Templates**: Curated micro‑habit templates; quick add; recommended chains.
- **Packs**: Themed packs (Study, Focus, Wellness); install/remove; local bundle or remote JSON (signed).
- **TipKit**: Contextual tips for discovery of advanced features.
- **Acceptance**: Template add ≤ 2 taps; packs install instantly; tips are helpful but not intrusive.

### Phase 7 — Sync, Collaboration, and Teams (Premium Tiers)
- **Cloud Sync**: Optional iCloud sync toggle; automatic conflict resolution; manual refresh.
- **SharePlay**: Co‑logging sessions for accountability; shared live activity.
- **Team Mode**: Invite teammates; group streaks; basic roles (admin/member). (Future multi‑target; staged rollout.)
- **Acceptance**: Sync reliable; no data loss; SharePlay stable; team flows behind feature flag.

### Phase 8 — Growth, Distribution, and Store Readiness
- **ASO**: Localized descriptions, screenshots, previews; annual‑first pricing emphasized.
- **Marketing**: TikTok 30‑sec habit series; launch plan on Product Hunt; Reddit outreach; press kit.
- **App Store**: Product Page Optimization tests; promo codes; subscription offers; intro messaging.
- **Support**: In‑app help link; mailto; FAQ; privacy requests flow.
- **Acceptance**: All review guidelines met; smooth purchase review; zero crashes in TestFlight cohort.

## Monetization Details
- **Tiers**: $4.99/mo, $24.99/yr, no trial; annual‑first default; upgrade/downgrade within subscription group.
- **Gating**: Pro gates: advanced analytics, template packs, sync, team mode (later tiers).
- **Offers**: Promotional win‑back for cancelled users; offer codes; territory appropriate pricing display.
- **Validation**: StoreKit 2 transaction verification; local on‑device receipt checks; restore purchases path.
- **Paywall UX**: Evidence‑based copy, social proof (later), A/B placements; haptics and micro‑animations.

## Notifications & Focus
- **Permissions**: Educate then ask; respect denial; settings deep links.
- **Scheduling**: Daypart defaults; quiet hours; Focus mode relevance score.
- **Templates**: Notification templates for streak save, chain nudge, goal celebrate.

## Widgets & Live Activities (Implementation Notes)
- **Widgets**: AppIntent‑driven interactivity; timeline updates on data change; placeholders and snapshots.
- **Live Activities**: ActivityAttributes for habit timer; update cadence; remote push support optional.
- **Testing**: Preview families; time traveling with `WidgetPreview` and `ActivityKit` debug tools.

## Accessibility
- **VoiceOver**: Meaningful labels and traits for all tappable items; combined accessibility elements in rows.
- **Dynamic Type**: Reflow layouts; minimum sizes honored; avoid truncation.
- **Contrast**: Test in light/dark and High Contrast modes; no info by color alone.
- **Motion**: Respect Reduce Motion; use opacity/scale transitions as fallback.

## Performance
- **Targets**: Cold start < 400ms perceived to first paint; interactions < 16ms budget on 60Hz.
- **Instruments**: Signposts around heavy operations (logging, paywall, purchase); fix hot paths.
- **Caching**: Derived metrics cache; eager precompute on device idle.

## Privacy & Security
- **Manifest**: `PrivacyInfo.xcprivacy` maintained; no tracking; minimal data categories.
- **ATS**: Enabled; document exceptions (none expected).
- **Data**: Keychain only for sensitive tokens (if any). No third‑party analytics. ATT not used.
- **Requests**: Clear prompts for permissions; local processing preferred.

## Localization & Internationalization
- **Coverage**: EN v1; add ES/DE/FR/JA after v1.1 with professional copy.
- **Process**: Use `LocalizedStringKey`; all UI strings in `Localizable.strings`.
- **Formats**: Date/time localized; number/currency aware paywall copy.

## Testing Strategy
- **Unit**: Service layer with protocol mocks (Network, Subscription, Analytics, Scheduler).
- **UI**: Snapshot/state introspection; navigation correctness; accessibility tests.
- **StoreKit**: Sandbox purchase flows; entitlement refresh; restore/cancel scenarios.
- **Widgets/Activities**: Timeline and rendering snapshots; intent performance tests.

## CI/CD & Release
- **CI**: Xcode Cloud or local CI to run tests and static checks on PRs.
- **Build**: Archive readiness; no extra setup; iOS 18 base.
- **TestFlight**: Alpha (internal) → Beta (external 100–500 users) → Release.
- **Metrics**: Crash‑free sessions, purchase conversion, day‑7 retention, notification open rate.

## Risk Register
- **Superficial habit loop**: Mitigate with chain depth metric; weekly deep session.
- **Notification fatigue**: Provide granular control and Focus integration.
- **Over‑complexity**: Stage features; maintain simplicity in default flows.

## Work Plan & Milestones
- **M0 (1–2 weeks)**: Phase 1 implementation; CRUD for habits; streaks; paywall gating; basic analytics.
- **M1 (2–3 weeks)**: Chains + Focus + Notifications; StoreKit purchase logic; A/B paywall placements.
- **M2 (2–3 weeks)**: Widgets + Live Activities; iPad enhancements; keyboard shortcuts.
- **M3 (2–4 weeks)**: Insights + Exports + Share Cards; template packs; TipKit.
- **M4 (3–5 weeks)**: Cloud sync; SharePlay; (prepare Team Mode scaffolds behind flags).
- **M5 (2 weeks)**: Hardening, perf, accessibility, localization (second language), ASO assets; App Store submission.

## Definition of Done (per release)
- **Functional**: Feature complete for scope; edge cases covered; no blockers.
- **Quality**: Zero crashes in TestFlight; core flows under latency targets; a11y passes.
- **Privacy**: Manifest updated; permissions minimal; ATS intact.
- **Store**: Screenshots, preview video, localized copy; subscription metadata set; age ratings reviewed.

---

### Backlog (Icebox)
- Research Focus Filters suggestions API tuning for richer relevance.
- Explore lightweight habit templates via signed JSON from a static CDN (ATS‑compliant), still local‑first.
- Investigate sub‑minute haptic patterns for Watch (future target), within Apple guidelines.
- Investigate simple calendar import/export bridges (on‑device only, with user consent).


