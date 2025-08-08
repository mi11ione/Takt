## Takt Design Roadmap (iPhone‑Only)

All core functionality is complete. Remaining scope is design: visuals, motion, and layouts. This roadmap contains only three phases focused on design.

### Completion Summary (already done)
- Habits (create/edit/archive/favorites), Chains (build/run), Timer with Live Activity progress, Insights (weekly/best‑hour/highlights), Nudges with quiet hours + actions, Templates & Packs, Paywall baseline, App Shortcuts, Privacy/Analytics.

---

## Phase 1 — Visual System Foundation
- Color & Theming
  - Define semantic color tokens (accent, surface, card, separator, success, warning) with light/dark variants
  - Apply consistent tint/foreground usage across all screens
- Typography & Spacing
  - Standardize text styles per surface (titles, headers, body, captions)
  - Establish an 8‑pt spacing grid for paddings/margins across lists, cards, forms
- Components
  - Cards (rounded corners, subtle shadow), Badges/Pills, Callouts (info/success), Banners (non‑blocking)
  - Buttons: primary/secondary/ghost styles building on `HapticButtonStyle`
  - Empty state templates with iconography and actionable guidance
- Iconography & Materials
  - Consistent SF Symbols; size/weight rules; tasteful use of materials where appropriate
- Widgets & Live Activity Visual Spec
  - Finalize look for small/medium widgets and micro‑timer Live Activity (lock screen + island)

Acceptance
- Visuals cohesive in light/dark; spacing consistent; typography readable with Dynamic Type.

Deliverables
- Color tokens in Assets; component styles (CardStyle/CalloutStyle/Button variants); updated views applying the system; widget/live activity visual spec.

---

## Phase 2 — Motion & Micro‑Interactions
- Animations
  - Micro‑timer: start/finish pulses; smooth progress updates; pause/resume affordances
  - Chains: step transitions (advance/skip) with subtle motion cues
  - Habit list: add/edit/archive transitions; section/header reveal
- Haptic Choreography
  - Map `.sensoryFeedback` to key moments: log success, chain complete, paywall present, template install
- State‑Driven Motion
  - Use `.phaseAnimator` and `.transition` to correlate motion with explicit states (idle/loading/loaded, running/paused/completed)
- Performance Guardrails
  - Ensure animations stay at 60fps; avoid layout thrash; measure with Instruments

Acceptance
- Motion clarifies state; haptics feel satisfying and not overused; consistent across screens.

Deliverables
- Animation modifiers for timer/chain/list; haptic mapping table; updated views with transitions and validated performance.

---

## Phase 3 — Layout Excellence & Theming Polish
- Layout
  - Harmonize grouped forms and lists; align paddings/headers/footers; safe‑area handling; home‑indicator spacing
  - Polished empty/zero‑states with clear calls‑to‑action (Templates, Chains, Insights)
- Theming
  - Refine backgrounds (subtle gradients/materials); card elevations; highlight colors for recommended actions
  - Consistent widget & live activity themes (icons, typography, spacing) in light/dark
- Accessibility & Contrast
  - Confirm color contrast; refine large‑text breakpoints; reduced‑motion alternates for key transitions

Acceptance
- App looks and feels unified; layouts intentional; accessible across Dynamic Type and high‑contrast; widgets/live activities visually consistent.

Deliverables
- Finalized layouts for Habits, Chains, Timer, Insights, Settings; widget/live activity theme kit; accessibility check report.


