# iPhone refresh-rate behavior and how to request 120Hz

## Why devices can appear locked to 80Hz
- ProMotion panels are **variable refresh rate** (10–120Hz). iOS dynamically chooses the current value to balance power, heat, and panel efficiency. The system often parks at **80Hz** for static or lightly animated scenes to save battery while keeping motion smooth.
- Low Power Mode, thermal throttling, or heavy background load further cap the refresh budget; these conditions are managed by the system and override per-app preferences.
- Apps that never ask for ProMotion explicitly (for example, leaving `CADisplayLink.preferredFramesPerSecond` at its default) allow the compositor to settle at an intermediate rate like 80Hz.

## What "fixing" means within an app
You cannot force 120Hz globally at the OS level without Apple-signed privileges. The best you can do is **request** the highest refresh rate your scene justifies and allow iOS to honor it when battery/thermal limits permit.

Use the new `preferredFrameRateRange` APIs to request 120Hz on supported hardware:

```swift
import UIKit
import QuartzCore

final class ProMotionViewController: UIViewController {
    private var displayLink: CADisplayLink?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        promoteTo120Hz()
    }

    private func promoteTo120Hz() {
        // Request 120Hz for the whole scene
        view.window?.windowScene?.preferredFrameRateRange = CAFrameRateRange(
            minimum: 80,
            maximum: 120,
            preferred: 120
        )

        // Align animations and timers to the same target
        let link = CADisplayLink(target: self, selector: #selector(tick))
        link.preferredFrameRateRange = CAFrameRateRange(minimum: 80, maximum: 120, preferred: 120)
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    @objc private func tick() {
        // Render or advance animations here
    }
}
```

### Guardrails to keep
- Detect hardware and fall back gracefully on non-ProMotion devices or when `preferredFrameRateRange` is unavailable (iOS < 15).
- Respect system states: pause or lower your target during Low Power Mode, Background App Refresh, or when Metal/SceneKit surfaces report thermal pressure.
- Avoid pegging 120Hz in views that do not benefit from it (e.g., static lists); use 120Hz only where user-visible motion is obvious, such as fast scrolling or interactive animations.

## How to verify
1. Run on a ProMotion device (e.g., iPhone 13 Pro or later) with Low Power Mode disabled.
2. In Xcode, open **Debug > View Debugging > Capture Display FPS** or profile with Instruments' **Core Animation** template to confirm the refresh rate hits 120Hz during active interaction.
3. While profiling, enable Low Power Mode or heat the device; you should see the rate step down to ~80Hz/60Hz, confirming that system governors, not code, control the upper bound.

## Global 120Hz is not permitted
Outside of jailbroken environments or Apple-internal tooling, there is no supported way to force **every app** or the system UI to 120Hz. Each app must request (not demand) a higher rate, and the OS may still reduce it. The guidance above ensures your own app participates correctly without fighting system policies.
