## Takt Roadmap (Revamped, iPhone‑Only)

This roadmap replaces the previous plan. It is iPhone‑focused and excludes iPad‑specific work. It removes items already implemented and presents a concise status plus a forward plan that fully covers the remaining features through five phases.

### What Takt Is (Product North Star)
Ultra‑fast micro‑habits (30–90s) you can complete instantly with delightful haptics. Focus on execution over planning. Surfaces: Lock Screen (widgets/live activities), App Shortcuts, and quick in‑app flows.

---

## Current Capabilities (Quick Summary)
The app today supports the following fully functional features:
- Habit library: create, edit, archive/unarchive, favorites, quick log
- Streaks: daily streak calculation and display
- Timer: micro‑timer with pause/resume/cancel/finish; logs on completion; haptic feedback
- Chains: create/edit (select + reorder), list/archiving, run chain step‑by‑step
- Insights: weekly count, best hour, habit highlights (longest streaks)
- Notifications: daypart nudges (morning/midday/afternoon/evening), opt‑in toggle in Settings
- Templates: starter templates (quick add)
- Paywall baseline: A/B after 3 logs (annual‑first policy placeholder)
- App Shortcuts: example intents in place (Log Habit / Open Streaks / Add Habit)
- Privacy & Analytics: Privacy Manifest stub, OSLog categories, MetricKit hooks

Everything above is implemented in‑app and working on iPhone.

---

## Out of Scope / Removed
- iPad‑specific layout and keyboard shortcut work (not required; SwiftUI already scales reasonably on iPad)
- Any previously listed items that are already built (to avoid duplication in the roadmap below)

---

## Phased Plan (All iPhone‑Only)
Each phase is designed to be independently shippable. Together they cover 100% of features described here.

### Phase 1 — Feature Expansion (High‑Value Additions)
- Interactive Widgets (Widget Extension)
  - Small/medium/large + lock screen accessory
  - Quick log, start timer, open chain, and open insights actions
  - AppIntent configuration (favorite habit/chain); placeholders and redacted states
- Live Activities (ActivityKit Target)
  - Micro‑timer in Dynamic Island/Lock Screen; start/pause/resume/cancel/finish
  - Progress updates tied to in‑app timer; dismissal policies
- App Shortcuts Expansion
  - Start timer for habit, start chain by name, log favorite
  - Better phrases and disambiguation; Spotlight donation
- Notifications (Nudges v1.1)
  - Quick action from notification to log or start timer
  - Quiet hours setting; per‑template opt‑out

Acceptance: Widgets and Live Activities reliably execute actions; Shortcuts resolve naturally; nudges respect quiet hours and opt‑outs.

### Phase 2 — Engaging & Complex Functionality
- Recommendations (On‑device)
  - Simple next‑best suggestion using recency, favorites, and time of day
  - “Start recommended” action on habit list and widget
- Templates & Packs v1
  - Curated packs (Focus Reset, Study Sprint, Wind‑Down); add/remove with clear copy
  - Template customization (duration/emoji) on add
- Insights v1.5
  - Weekly trend cards; chain depth evolution; personal best streaks
  - Share Cards (image export) for streaks/chains

Acceptance: Recommendations feel relevant (>60% acceptance on suggested starts in test cohort); packs install quickly; insights show meaningful trends under 10s scan time.

### Phase 3 — Design Enhancements (Delight & Clarity)
- Motion & Transitions
  - Micro‑timer animations (start/finish pulses), chain step transitions, list interactions
- Visual Design
  - Consistent cards, color system, shadows, and vibrancy; refined widget visuals
- Layout Polish
  - Empty states, highlights, and banners; better grouping and spacing; improved iconography

Acceptance: UI feels consistent and joyful; animations enhance clarity; accessible in light/dark and across Dynamic Type settings.

### Phase 4 — Quality Pass (Bugs, Edge Cases, Perf)
- Bug Fixes & Edge Cases
  - Streak edge cases (time zone/day boundaries); chain interruptions; notification duplication
- Performance
  - Startup and interaction timing goals; smooth scrolling; timer accuracy checks
- Accessibility
  - VoiceOver descriptions for timer, chains, and insights; large hit targets; reduced motion fallbacks

Acceptance: Zero known P1/P2 bugs; a11y checks pass; performance budgets met on iPhone test devices.

### Phase 5 — Total Checkup (Store Readiness)
- StoreKit 2 Finalization
  - Product IDs, purchase/restore flows, verified entitlements, win‑back offers
- App Store Package
  - Screenshots (widget, timer, chain), preview video, localized copy, privacy text
- Final QA
  - TestFlight sign‑off; crash‑free sessions goal; final polish on copy and nudges

Acceptance: App is archive‑clean; purchase flows verified; store assets uploaded; internal sign‑offs complete.

---

## Guarantees
- All features described in this roadmap will be implemented within these phases.
- iPhone experience remains first‑class; no iPad‑specific scope required.
- Each phase stands on its own for incremental shipping.


