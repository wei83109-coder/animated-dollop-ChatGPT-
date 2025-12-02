import SwiftUI
import PlaygroundSupport

// MARK: - Sample data

let quickActions: [QuickAction] = [
    QuickAction(
        title: "Copy PR review checklist",
        description: "Ensure builds, tests, screenshots, and copy have been verified before approval.",
        payload: PromptLibrary.load(named: "pr_review_checklist") ?? "Review checklist: ✅ Build passes, ✅ Tests pass, ✅ Screenshots provided, ✅ Copy reviewed"
    ),
    QuickAction(
        title: "Draft responses for notifications",
        description: "Send your GitHub inbox context to NovaFlux for triage and suggested replies.",
        payload: PromptLibrary.load(named: "notification_triage_prompt") ?? "Draft responses to my GitHub notifications"
    )
]

// MARK: - View

struct GitHubStarterView: View {
    @State private var statusMessage = "Ready to launch NovaFlux Automator."
    @State private var isTriggering = false
    private let client = NovaFluxClient()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header

                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick actions")
                        .font(.title3)
                        .bold()
                    ForEach(quickActions) { action in
                        QuickActionCard(action: action, perform: handleQuickAction)
                    }
                }

                VStack(spacing: 12) {
                    Text("Automation")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

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
                        .padding(.top, 4)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Text("GitHubStarter for iOS")
                .font(.largeTitle)
                .bold()
            Text("NovaFlux Automator pairs Codex with GitHub quick actions on your iPhone or iPad.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    private func handleQuickAction(_ action: QuickAction) {
        statusMessage = Clipboard.copy(action.payload)
    }

    private func triggerAutomation() {
        isTriggering = true
        statusMessage = "Preparing request with API base: \(client.buildRequest(prompt: "repo triage").url?.absoluteString ?? "unknown")"

        Task {
            let prompt = quickActions.last?.payload ?? "Triage my GitHub notifications and draft responses"
            let response = await client.trigger(prompt: prompt)
            await MainActor.run {
                statusMessage = response
                isTriggering = false
            }
        }
    }
}

PlaygroundPage.current.setLiveView(GitHubStarterView())
