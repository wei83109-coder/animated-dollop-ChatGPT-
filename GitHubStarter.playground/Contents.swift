import SwiftUI
import PlaygroundSupport

/// Minimal preview demonstrating the GitHubStarter intent.
struct GitHubStarterView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("GitHubStarter for iOS")
                .font(.largeTitle)
                .bold()
            Text("Quick actions and guidance for collaborating on GitHub from your iPhone or iPad.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Copy PR review checklist") {
                UIPasteboard.general.string = "Review checklist: ✅ Build passes, ✅ Tests pass, ✅ Screenshots provided, ✅ Copy reviewed"
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

PlaygroundPage.current.setLiveView(GitHubStarterView())
