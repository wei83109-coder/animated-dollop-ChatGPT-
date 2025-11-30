# GitHubStarter for iOS Roadmap

This roadmap outlines the concrete files and features to add so the Swift Playgrounds experience can grow into a shippable iOS automation companion for GitHub users.

## Files and structure to add
- `GitHubStarter.playground/Contents.swift`: SwiftUI-based live view that renders the onboarding cards and quick-action buttons.
- `GitHubStarter.playground/Sources/PlaygroundSupport.swift`: Helper utilities for clipboard actions, haptics, and layout constants used across pages.
- `GitHubStarter.playground/Resources/`: Asset catalog for GitHub and Codex artwork plus markdown prompt templates.
- `Tests/GitHubStarterTests.swift`: Lightweight unit tests for button handlers and prompt-loading utilities to keep the playground stable.
- `.github/workflows/ci.yml`: CI pipeline to lint Swift, build the playground in Xcode, and run unit tests on macOS runners.
- `CONTRIBUTING.md`: Collaboration guide that explains branch strategy, coding style, and how to run checks locally.

## Features to prioritize
1. **Onboarding carousel**: Multi-card walkthrough that explains GitHub on iOS, Codex usage, and available quick actions.
2. **Quick actions tray**: One-tap buttons to copy issue templates, PR review checklists, and Codex prompt snippets to the clipboard with success toasts.
3. **Repository shortcuts**: Buttons that deep-link into the GitHub app for Issues, PRs, Discussions, and Notifications for a chosen repo.
4. **Offline-ready content**: Bundle markdown templates in Resources so prompts and checklists work without network access.
5. **Theme support**: Respect system light/dark modes with accessible colors and dynamic type.
6. **Haptic feedback**: Light taps on primary actions and warnings for error states, using `UIImpactFeedbackGenerator`.
7. **Error handling**: User-friendly messaging when clipboard writes fail or deep links are unavailable, with retry guidance.
8. **Telemetry hooks**: Optional, privacy-friendly metrics for button taps and carousel completion (opt-in with clear messaging).

## Testing expectations
- Add unit tests for clipboard helpers, prompt-loading functions, and deep-link builders.
- Include UI snapshot tests (Xcode) to prevent regressions in the onboarding cards and quick-action tray.
- Validate the playground opens cleanly in Swift Playgrounds and Xcode by running `xcodebuild -scheme GitHubStarter -destination "platform=iOS Simulator,name=iPhone 15" build` in CI.
- Provide a manual test script that covers the carousel, quick actions, clipboard flows, and deep-link buttons.

## Milestones
- **MVP**: Onboarding carousel + quick actions + clipboard helpers + bundled prompts.
- **Beta**: Deep-link shortcuts, theme support, haptics, and initial tests/CI.
- **Release**: Error handling polish, telemetry hooks, full documentation, and accessibility review.
