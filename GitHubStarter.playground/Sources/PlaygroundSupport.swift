import Foundation
import SwiftUI
import UIKit

public struct QuickAction: Identifiable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let payload: String

    public init(title: String, description: String, payload: String) {
        self.title = title
        self.description = description
        self.payload = payload
    }
}

public enum PromptLibrary {
    public static func load(named resource: String, withExtension ext: String = "md") -> String? {
        guard let url = Bundle.main.url(forResource: resource, withExtension: ext) else {
            return nil
        }
        return try? String(contentsOf: url)
    }
}

public enum Clipboard {
    @discardableResult
    public static func copy(_ text: String) -> String {
        UIPasteboard.general.string = text
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        return "Copied to clipboard — paste anywhere to share."
    }
}

public struct NovaFluxConfig {
    public let baseURL: URL
    public let apiKey: String

    public init(baseURL: URL, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }

    public static func load() -> NovaFluxConfig {
        let env = ProcessInfo.processInfo.environment
        let base = env["NOVFLUX_API_BASE"] ?? "https://api.novaflux.example/v1"
        let key = env["NOVFLUX_API_KEY"] ?? "nova-demo-key-please-replace"

        // Keep the playground resilient if an invalid URL is provided via the environment.
        let validatedBaseURL = URL(string: base) ?? URL(string: "https://api.novaflux.example/v1")!

        return NovaFluxConfig(baseURL: validatedBaseURL, apiKey: key)
    }
}

public final class NovaFluxClient {
    private let config: NovaFluxConfig

    public init(config: NovaFluxConfig = .load()) {
        self.config = config
    }

    public func buildRequest(prompt: String) -> URLRequest {
        // Avoid leading slashes so the path appends to any baseURL segment (e.g., https://api.example/v1)
        var request = URLRequest(url: config.baseURL.appendingPathComponent("automations"))
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

    public func trigger(prompt: String) async -> String {
        let request = buildRequest(prompt: prompt)

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

public struct QuickActionCard: View {
    public let action: QuickAction
    public let perform: (QuickAction) -> Void

    public init(action: QuickAction, perform: @escaping (QuickAction) -> Void) {
        self.action = action
        self.perform = perform
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(action.title)
                .font(.headline)
            Text(action.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Button("Copy") {
                perform(action)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
