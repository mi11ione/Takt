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


