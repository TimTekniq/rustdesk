# Tekniq test 9 — source and validation status

2026-09-07, base f79e8851aa43d9744ee27acb234eeb3779bce78f. User approved the
repair plan. Local source only: no commit, push, public source synchronization,
signing or deployment. Existing hbb_common changes preserved.

## Repairs

- Removed indiscriminate product-family process termination at startup.
- Windows main-window routing now uses a stable property, with compatibility
  for older captions. Exact FindWindowW lookup previously missed the caption
  changed by getWindowName() to e.g. Tekniq Hulp · test 8.
- Embedded CM reports readiness from its own listener, not a socket probe of
  another process. Listener failure no longer quits the main process and shows
  an error in the customer page. The wait helper creates no nested runtime.
- Windows Hulp waits for the main consent handler, never launches a fallback CM.
- Main customer state uses no CM tabs/focus/minimize timers. Reject and stop
  notify the UI. Customer main window is not always-on-top.
- Existing customer presentation extracted into a testable widget: code,
  accept/reject, active state and startup error remain in one page.
- Screen-switch setup failures propagate through FFI; failed local requests do
  not close the current viewer. Queuing success is NOT handover completion.
- Beheer margins 12px, column gap 16px. Saved customers and logos preserved.
- Native/custom titlebars show test 9. CI includes the new regression checks.

NEW IMPLEMENTATION REQUIRED

Inspected the existing Windows FindWindowW lookup, process-family kill helper,
CM initialization and socket probe. None provides caption-independent instance
identity or owned-listener readiness. Added small helpers
tekniq_window_identity.h and cm_lifecycle.rs; no third-party dependency added.

## Validation

- rustc --test --edition=2021 src/cm_lifecycle.rs: 4 tests passed.
- MSVC build/run of tests/tekniq_window_identity_test.cpp: 7 assertions passed
  using hidden real Win32 windows, without touching running customer sessions.
- flutter test --no-pub test/tekniq_customer_panel_test.dart: 2 tests passed,
  including accept/reject/stop/transitions, 560x640 layout and visible error.
- Dart analysis of extracted customer panel and test: no issues.
- git diff --check: passed.
- Full cargo check --locked --features flutter did NOT pass. After configuring
  VCPKG_ROOT and LIBCLANG_PATH, magnum-opus failed because the local vcpkg install
  lacks opus/opus_multistream.h. Flutter/Rust generated bridge files are also
  absent locally; prior CI bridge artifact is expired. Full FFI/app compilation
  and packaging remain unverified. No new app executable/hash exists.

## Required before publishing

1. Explicit approval to commit/push, synchronize public source and run existing
   isolated GitHub workflow. Regenerate bridge and build BOTH Hulp and Beheer.
2. Check metadata, version/build label, SHA256, signing status and Defender scan
   without remediation. Ordinary customer download remains unchanged.
3. Two-PC test on exact new binaries: reject/accept in main customer window,
   minimize/restore, stop/reconnect, restart and launch another downloaded copy
   while connected. One usable customer window, no session killed by relaunch.
4. Show operator screen, verify video and blocked customer mouse/keyboard,
   switch back and repeat. Correlate both endpoint logs. No two-PC test yet;
   do not claim success from a queued-token message or successful build alone.
5. Only after validation publish the hidden test binaries; no ordinary-download
   promotion without separate authorization.

## Review scope and residual risks

Affected: Rust startup/IPC, Flutter presentation/model/actions, Windows runner,
tests, build checks. Storage, logos, authentication policy, relay configuration,
signing and ordinary download unchanged. No Tekla geometry/creator/XAML layers.
Full native/FFI compile, simultaneous cold-launch handling and network handover
remain unverified end-to-end. View-only permissions still require a two-PC test.
