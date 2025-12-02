# GitHubStarter for iOS

A Swift Playgrounds experience that helps newcomers use GitHub on iOS. It explains what GitHub and Codex can do on mobile and offers one-tap quick actions for common collaboration tasks. The latest playground build also wires in **NovaFlux Automator**, a fictional Codex-powered API to draft replies and triage GitHub work from your device.

## What it does
- Introduces GitHub on iOS, including browsing, reviews, and notifications.
- Explains how Codex can assist with summaries, documentation, and prompts while on mobile.
- Provides quick actions to copy issue templates, PR review checklists, repository links, and ready-to-use prompts for Codex.
- Builds an authenticated request to the NovaFlux Automator API so you can test end-to-end automation flows with your own credentials.

## Run it on your device
1. Download the repository on a Mac or in Files on iPad/iPhone.
2. Open `src/frontend/GitHubStarter.playground` in Swift Playgrounds (iOS/iPadOS) or Xcode.
3. Tap **Run** to view the guided experience.

### Configure the NovaFlux API
- Export your endpoint and key as environment variables before opening the playground: `export NOVFLUX_API_BASE="https://api.novaflux.example/v1"` and `export NOVFLUX_API_KEY="your-real-api-key"`.
- Defaults are included for quick demos, but replacing them with a live base URL and key will let the "Trigger NovaFlux automation" button perform a real call via `URLSession`.

## For first-time collaborators
- Install the official GitHub app and sign in.
- Star repositories to bookmark them, then open issues labeled **good first issue**.
- Use the quick actions in the playground to copy prompts and templates directly to your clipboard.

## Testing the repository
1. Create a Python virtual environment (`python -m venv .venv && source .venv/bin/activate`) and install the only dependency: `pip install -r requirements.txt`.
2. Run `pytest` to execute a lightweight structural test suite that ensures the repository contains the expected playground files, documentation, and refresh-rate guidance.
3. For a manual end-to-end check, open `src/frontend/GitHubStarter.playground` in Swift Playgrounds or Xcode and confirm the live view renders with the GitHub and Codex guidance cards plus quick-action buttons.

## What to add next
- Build the actual Swift playground described in this README (`GitHubStarter.playground/Contents.swift`) with SwiftUI cards and buttons.
- Extract reusable helpers into `Sources/` for clipboard handling, haptics, and deep links, and bundle prompt templates in `Resources/`.
- Add a small `Tests/` target that validates clipboard actions, prompt loading, and deep-link generation.
- Wire up CI in `.github/workflows/ci.yml` to build the playground on macOS runners and surface lint/test results.

For a detailed feature and file roadmap, see [ROADMAP.md](ROADMAP.md).

## Refresh-rate behavior on iPhone
If the playground eventually embeds high-motion views, see [configs/REFRESH_RATE.md](configs/REFRESH_RATE.md) for why ProMotion devices may sit at 80Hz and how to request 120Hz responsibly inside the app.

## Repository layout
- `src/frontend/` holds the Swift playground and UI assets. The existing `GitHubStarter.playground` now lives here alongside an `assets/` folder for visual resources.
- `src/backend/` is dedicated to API-facing code such as the NovaFlux Automator client surface.
- `configs/` stores operational or platform-specific guidance, starting with refresh-rate documentation for motion-heavy views.
- `tests/` contains Python tests that validate the presence and organization of the project scaffold.
