# GitHubStarter for iOS

A Swift Playgrounds experience that helps newcomers use GitHub on iOS. It explains what GitHub and Codex can do on mobile and offers one-tap quick actions for common collaboration tasks.

## What it does
- Introduces GitHub on iOS, including browsing, reviews, and notifications.
- Explains how Codex can assist with summaries, documentation, and prompts while on mobile.
- Provides quick actions to copy issue templates, PR review checklists, repository links, and ready-to-use prompts for Codex.

## Run it on your device
1. Download the repository on a Mac or in Files on iPad/iPhone.
2. Open `GitHubStarter.playground` in Swift Playgrounds (iOS/iPadOS) or Xcode.
3. Tap **Run** to view the guided experience.

## For first-time collaborators
- Install the official GitHub app and sign in.
- Star repositories to bookmark them, then open issues labeled **good first issue**.
- Use the quick actions in the playground to copy prompts and templates directly to your clipboard.

## Testing the repository
1. Create a Python virtual environment (`python -m venv .venv && source .venv/bin/activate`) and install the only dependency: `pip install -r requirements.txt`.
2. Run `pytest` to execute a lightweight structural test suite that ensures the repository contains the expected playground files, documentation, and refresh-rate guidance.
3. For a manual end-to-end check, open `GitHubStarter.playground` in Swift Playgrounds or Xcode and confirm the live view renders with the GitHub and Codex guidance cards plus quick-action buttons.

## What to add next
- Build the actual Swift playground described in this README (`GitHubStarter.playground/Contents.swift`) with SwiftUI cards and buttons.
- Extract reusable helpers into `Sources/` for clipboard handling, haptics, and deep links, and bundle prompt templates in `Resources/`.
- Add a small `Tests/` target that validates clipboard actions, prompt loading, and deep-link generation.
- Wire up CI in `.github/workflows/ci.yml` to build the playground on macOS runners and surface lint/test results.

For a detailed feature and file roadmap, see [ROADMAP.md](ROADMAP.md).

## Refresh-rate behavior on iPhone
If the playground eventually embeds high-motion views, see [REFRESH_RATE.md](REFRESH_RATE.md) for why ProMotion devices may sit at 80Hz and how to request 120Hz responsibly inside the app.
