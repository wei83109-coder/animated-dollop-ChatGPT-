 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/README.md b/README.md
index ec88406279c274da56a09025b80a902702090951..515d637570ce661f729056a1c039ade0decbca59 100644
--- a/README.md
+++ b/README.md
@@ -1,2 +1,21 @@
-# animated-dollop-ChatGPT-
-All of this was done by ChatGPT
+# GitHubStarter for iOS
+
+A Swift Playgrounds experience that helps newcomers use GitHub on iOS. It explains what GitHub and Codex can do on mobile and offers one-tap quick actions for common collaboration tasks.
+
+## What it does
+- Introduces GitHub on iOS, including browsing, reviews, and notifications.
+- Explains how Codex can assist with summaries, documentation, and prompts while on mobile.
+- Provides quick actions to copy issue templates, PR review checklists, repository links, and ready-to-use prompts for Codex.
+
+## Run it on your device
+1. Download the repository on a Mac or in Files on iPad/iPhone.
+2. Open `GitHubStarter.playground` in Swift Playgrounds (iOS/iPadOS) or Xcode.
+3. Tap **Run** to view the guided experience.
+
+## For first-time collaborators
+- Install the official GitHub app and sign in.
+- Star repositories to bookmark them, then open issues labeled **good first issue**.
+- Use the quick actions in the playground to copy prompts and templates directly to your clipboard.
+
+## Testing the repository
+There are no automated tests for the Swift playground. To verify the repository works, open the playground in Swift Playgrounds or Xcode and confirm the live view renders with the GitHub and Codex guidance cards plus quick-action buttons.
 
EOF
)