# GitHubStarter for iOS

A Swift Playgrounds experience that helps newcomers use GitHub on iOS. It explains what GitHub and Codex can do on mobile and offers one-tap quick actions for common collaboration tasks. The latest playground build also wires in **NovaFlux Automator**, a fictional Codex-powered API to draft replies and triage GitHub work from your device.

## What it does
- Introduces GitHub on iOS, including browsing, reviews, and notifications.
- Explains how Codex can assist with summaries, documentation, and prompts while on mobile.
- Provides quick actions to copy issue templates, PR review checklists, repository links, and ready-to-use prompts for Codex.
- Builds an authenticated request to the NovaFlux Automator API so you can test end-to-end automation flows with your own credentials.

## Repository layout
- `GitHubStarter.playground/Contents.swift`: Entry point that wires quick actions, NovaFlux automation, and the live view.
- `GitHubStarter.playground/Sources/`: Reusable helpers for quick-action models, clipboard handling, and NovaFlux requests.
- `GitHubStarter.playground/Resources/`: Prompt templates and checklists that power clipboard actions and NovaFlux payloads.
- `tests/`: Lightweight structural tests to keep the scaffolding intact.

## Run it on your device
1. Download the repository on a Mac or in Files on iPad/iPhone.
2. Open `GitHubStarter.playground` in Swift Playgrounds (iOS/iPadOS) or Xcode.
3. Tap **Run** to view the guided experience.

### Configure the NovaFlux API
- Export your endpoint and key as environment variables before opening the playground: `export NOVFLUX_API_BASE="https://api.novaflux.example/v1"` and `export NOVFLUX_API_KEY="your-real-api-key"`.
- Defaults are included for quick demos, but replacing them with a live base URL and key will let the "Trigger NovaFlux automation" button perform a real call via `URLSession`.

## For first-time collaborators
- Install the official GitHub app and sign in.
- Star repositories to bookmark them, then open issues labeled **good first issue**.
- Use the quick actions in the playground to copy prompts and templates directly to your clipboard.

## Testing the repository
1. Create a Python virtual environment (`python -m venv .venv && source .venv/bin/activate`) and install the dependencies, which now include the OpenAI SDK for future automation tooling: `pip install -r requirements.txt`.
2. Run `pytest` (or `make test`) to execute a lightweight structural test suite that ensures the repository contains the expected playground files, documentation, and refresh-rate guidance.
3. For a manual end-to-end check, open `GitHubStarter.playground` in Swift Playgrounds or Xcode and confirm the live view renders with the GitHub and Codex guidance cards plus quick-action buttons.

## Automation and CI
- Run `python -m automation.tasks verify` or `make automation` to validate the repository layout and ensure prompt resources are present.
- Preview the NovaFlux payload that the playground builds with `python -m automation.tasks novaflux "your prompt here"` to confirm the request body and headers before testing on device.
- List bundled quick actions via `python -m automation.tasks actions` to see which prompts ship with the playground.
- Use `scripts/bootstrap.sh` for a one-command setup (creates a virtual environment, installs dependencies, and runs the validation checks).
- CI is wired through `.github/workflows/ci.yml` to install dependencies, run tests, and execute the automation verifier on every push and pull request.

## What to add next
- Expand the NovaFlux automation flow to surface the API response in the UI and support retries or timeouts.
- Add haptics and sound options to the quick-action cards so clipboard actions feel responsive on device.
- Create a small `Tests/` target that validates clipboard actions, prompt loading, and deep-link generation.
- Wire up CI in `.github/workflows/ci.yml` to build the playground on macOS runners and surface lint/test results.

For a detailed feature and file roadmap, see [ROADMAP.md](ROADMAP.md).

## Refresh-rate behavior on iPhone
If the playground eventually embeds high-motion views, see [REFRESH_RATE.md](REFRESH_RATE.md) for why ProMotion devices may sit at 80Hz and how to request 120Hz responsibly inside the app.
