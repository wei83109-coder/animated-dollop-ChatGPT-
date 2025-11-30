import SwiftUI
import PlaygroundSupport
import UIKit

// MARK: - API configuration

/// Configuration object that carries the API endpoint and key for NovaFlux Automator, a fictional
/// Codex-enabled assistant for GitHub workflows on iOS.
struct NovaFluxConfig {
    let baseURL: URL
    let apiKey: String

    /// Loads configuration from environment variables with sensible defaults so the playground
    /// can run immediately.
    static func load() -> NovaFluxConfig {
        let env = ProcessInfo.processInfo.environment
        let base = env["NOVFLUX_API_BASE"] ?? "https://api.novaflux.example/v1"
        let key = env["NOVFLUX_API_KEY"] ?? "nova-demo-key-please-replace"
        return NovaFluxConfig(baseURL: URL(string: base)!, apiKey: key)
    }
}

/// Minimal client that builds an authenticated request. The actual network call is optional so
/// the playground remains safe to run without a real backend.
final class NovaFluxClient {
    private let config: NovaFluxConfig

    init(config: NovaFluxConfig = .load()) {
        self.config = config
    }

    func buildRequest(prompt: String) -> URLRequest {
        var request = URLRequest(url: config.baseURL.appendingPathComponent("/automations"))
        request.httpMethod = "POST"
        request.setValue("Bearer \(config.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "intent": "mobile-github-assistant",
            "prompt": prompt,
            "device": "swift-playgrounds"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return request
    }

    func trigger(prompt: String) async -> String {
        let request = buildRequest(prompt: prompt)

        // Avoid performing a real network call when the user has not configured a real key.
        if config.apiKey.contains("demo-key") || config.baseURL.host?.contains("example") == true {
            return "Request ready with demo key; set NOVFLUX_API_BASE and NOVFLUX_API_KEY for live calls."
        }

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse {
                return http.statusCode == 200 ? "NovaFlux automation triggered successfully." : "API responded with status \(http.statusCode)."
            }
            return "Received a non-HTTP response."
        } catch {
            return "Request failed: \(error.localizedDescription)"
        }
    }
}

/// Minimal preview demonstrating the GitHubStarter intent with NovaFlux Automator wiring.
struct GitHubStarterView: View {
    @State private var statusMessage = "Ready to launch NovaFlux Automator."
    @State private var isTriggering = false
    private let client = NovaFluxClient()

    var body: some View {
        VStack(spacing: 16) {
            Text("GitHubStarter for iOS")
                .font(.largeTitle)
                .bold()
            Text("NovaFlux Automator pairs Codex with GitHub quick actions on your iPhone or iPad.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Copy PR review checklist") {
                UIPasteboard.general.string = "Review checklist: ✅ Build passes, ✅ Tests pass, ✅ Screenshots provided, ✅ Copy reviewed"
                statusMessage = "Checklist copied — paste anywhere to share."
            }
            .buttonStyle(.borderedProminent)

            Button(action: triggerAutomation) {
                if isTriggering {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Text("Trigger NovaFlux automation")
                }
            }
            .buttonStyle(.bordered)

            Text(statusMessage)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
        .padding()
    }

    private func triggerAutomation() {
        isTriggering = true
        statusMessage = "Preparing request with API base: \(client.buildRequest(prompt: "repo triage").url?.absoluteString ?? "unknown")"

        Task {
            let response = await client.trigger(prompt: "Triage my GitHub notifications and draft responses")
            await MainActor.run {
                statusMessage = response
                isTriggering = false
            }
        }
    }
}

PlaygroundPage.current.setLiveView(GitHubStarterView())
