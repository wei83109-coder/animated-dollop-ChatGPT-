import SwiftUI
import PlaygroundSupport
import UIKit

struct LiquidGlassBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(#colorLiteral(red: 0.176, green: 0.267, blue: 0.455, alpha: 1)), Color(#colorLiteral(red: 0.082, green: 0.082, blue: 0.149, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            Circle()
                .fill(LinearGradient(colors: [Color(#colorLiteral(red: 0.427, green: 0.69, blue: 1, alpha: 0.9)), Color(#colorLiteral(red: 0.471, green: 0.949, blue: 0.965, alpha: 0.7))], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 380, height: 380)
                .offset(x: -120, y: -220)
                .blur(radius: 40)

            Circle()
                .fill(LinearGradient(colors: [Color(#colorLiteral(red: 0.957, green: 0.502, blue: 0.824, alpha: 0.8)), Color(#colorLiteral(red: 0.239, green: 0.557, blue: 0.988, alpha: 0.6))], startPoint: .topTrailing, endPoint: .bottomLeading))
                .frame(width: 420, height: 420)
                .offset(x: 160, y: -120)
                .blur(radius: 60)

            Circle()
                .fill(LinearGradient(colors: [Color(#colorLiteral(red: 0.235, green: 0.965, blue: 0.78, alpha: 0.8)), Color(#colorLiteral(red: 0.098, green: 0.463, blue: 0.949, alpha: 0.7))], startPoint: .bottomLeading, endPoint: .topTrailing))
                .frame(width: 460, height: 460)
                .offset(x: -80, y: 260)
                .blur(radius: 60)
        }
    }
}

struct GlassCard<Content: View>: View {
    var title: String
    var subtitle: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2).bold()
                .foregroundStyle(Color.white.opacity(0.95))
            Text(subtitle)
                .font(.callout)
                .foregroundStyle(Color.white.opacity(0.75))
            content
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                .shadow(color: Color.black.opacity(0.15), radius: 18, x: 0, y: 12)
        )
    }
}

struct QuickAction: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let caption: String
    let clipboardText: String
}

let quickActions: [QuickAction] = [
    QuickAction(icon: "square.and.pencil", title: "Issue template", caption: "Copy a ready-to-file issue", clipboardText: "## Expected behavior\n\n## Actual behavior\n\n## Steps to reproduce\n1. \n2. \n3. \n\n## Notes\n"),
    QuickAction(icon: "checkmark.seal", title: "PR review list", caption: "Stay consistent in reviews", clipboardText: "- [ ] Build passes\n- [ ] Tests added/updated\n- [ ] Docs updated\n- [ ] UX verified\n"),
    QuickAction(icon: "globe", title: "Repo link", caption: "Share this starter instantly", clipboardText: "https://github.com/your-org/GitHubStarter"),
    QuickAction(icon: "sparkles", title: "Codex prompt", caption: "Summon quick guidance", clipboardText: "Summarize this pull request for a mobile reviewer and list any migration steps."),
]

struct QuickActionButton: View {
    var action: QuickAction
    @Binding var copiedAction: String?

    var body: some View {
        Button {
            UIPasteboard.general.string = action.clipboardText
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75, blendDuration: 0.4)) {
                copiedAction = action.title
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: action.icon)
                    .font(.title3.weight(.semibold))
                    .frame(width: 36, height: 36)
                    .background(
                        LinearGradient(colors: [Color.white.opacity(0.28), Color.white.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                VStack(alignment: .leading, spacing: 4) {
                    Text(action.title)
                        .font(.headline)
                    Text(action.caption)
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.8))
                }
                Spacer()
                if copiedAction == action.title {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Image(systemName: "doc.on.doc")
                        .foregroundStyle(Color.white.opacity(0.8))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(14)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.22), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ContentView: View {
    @State private var copiedAction: String?

    var body: some View {
        ZStack {
            LiquidGlassBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("GitHub Starter")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(Color.white)
                        Text("Liquid glass UI")
                            .font(.headline)
                            .foregroundStyle(Color.white.opacity(0.8))
                        Text("Learn GitHub on iOS with Codex prompts, quick actions, and clipboard-ready templates.")
                            .foregroundStyle(Color.white.opacity(0.72))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)

                    GlassCard(title: "GitHub on iOS", subtitle: "Browse repos, review PRs, and catch up on notifications without leaving your phone.") {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Keep drafts synced with pull requests", systemImage: "arrow.triangle.2.circlepath")
                            Label("Reply to code comments with rich markdown", systemImage: "text.bubble")
                            Label("Turn notifications into tasks with swipe actions", systemImage: "bell")
                        }
                        .foregroundStyle(Color.white.opacity(0.86))
                    }
                    .padding(.horizontal)

                    GlassCard(title: "Codex assist", subtitle: "Use Copilot Chat to summarize context, draft release notes, or design onboarding prompts.") {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Summaries of diffs and issues", systemImage: "sparkles")
                            Label("Generate docs while you review", systemImage: "doc.text.magnifyingglass")
                            Label("Ask for mobile-friendly repro steps", systemImage: "iphone")
                        }
                        .foregroundStyle(Color.white.opacity(0.86))
                    }
                    .padding(.horizontal)

                    GlassCard(title: "Quick actions", subtitle: "Copy templates and prompts to keep collaboration moving.") {
                        VStack(spacing: 12) {
                            ForEach(quickActions) { action in
                                QuickActionButton(action: action, copiedAction: $copiedAction)
                            }
                        }
                    }
                    .padding(.horizontal)

                    GlassCard(title: "Try it live", subtitle: "Run the playground and share feedback with your team.") {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Tap any action to copy it", systemImage: "hand.tap")
                            Label("Blend the glass cards into your own brand", systemImage: "paintpalette")
                            Label("Ready for Swift Playgrounds or Xcode previews", systemImage: "play.rectangle")
                        }
                        .foregroundStyle(Color.white.opacity(0.86))
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 40)
                }
                .padding(.top, 30)
                .padding(.bottom, 60)
            }
        }
        .preferredColorScheme(.dark)
    }
}

PlaygroundPage.current.setLiveView(ContentView())
