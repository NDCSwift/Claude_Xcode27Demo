# 🤖 Xcode 27 Agentic Coding Demo

A SwiftUI tip-splitter built, reviewed, and verified on the iPhone 17 Pro simulator by Claude Agent inside Xcode 27 — planned with `/plan`, reviewed line by line, and tapped through on the simulator without a human hand on the mouse.

---

## 💻 Prompts & Terminal Commands Used

Everything typed on camera, in order.

### AI Prompts

**Project rules — `CLAUDE.md`**
```markdown
# AgentLoopDemo
- SwiftUI, iOS 27, iPhone only. Don't add macOS code paths.
- Keep logic in plain structs. No view models for a single screen.
- Give every control a test would need an accessibilityIdentifier.
- In plans, give the reason for each choice, not just the change.
- Verify UI changes on the iPhone 17 Pro simulator before saying you're done.
- Ask before changing signing, entitlements, or build settings.
```

**Plan mode — the initial ask**
```text
/plan A tip splitter: a bill amount, a tip of 15, 18, 20 or 25 percent, a number of people, and what each person pays.
```

**Agent-driven simulator verification**
```text
Run it on the iPhone 17 Pro simulator. Enter 84, choose 20%, set 3 people, and screenshot the total.
```

**"Crank it up a notch" — a full feature end to end**
```text
In target <AppTarget>, create a NEW file `NearbyCheckInView.swift`: a SwiftUI screen
with a "Check In Here" button that requests When-In-Use location, shows the current
coordinates, and saves the last check-in to a shared App Group so a future widget can
read it.

Do all of the following, using the Xcode tools rather than editing files by hand:
1. Logging — add an os.Logger (subsystem = bundle ID, category "CheckIn") and log
   authorization changes, location fixes, and save success/failure.
2. Info.plist — use AddInfoPlist to add NSLocationWhenInUseUsageDescription with a
   user-friendly string.
3. Entitlements — use AddEntitlement to add com.apple.security.application-groups
   with group.<bundle-id>.shared.
4. Localization — put all user-facing strings in the String Catalog (StringCatalogEdit). Create one if it does not exist
5. Preview — add a #Preview and use RenderPreview to show me it.
6. Build — BuildProject; if it fails, read GetBuildLog and fix it.
7. Run it for real — start a workspace device session on an iOS 27 simulator, install
   and run, open this screen, tap "Check In Here", accept the location prompt, and
   screenshot the result.
8. Logs — pull GetConsoleOutput and show me the "CheckIn" log lines proving it worked.
9. End the device session, then give me a short summary of every tool used.
```

**Auditing what the agent can reach**
```text
List the exact names of every mcp__xcode-tools__ tool you have.
```

**Re-testing after `settings.json` denies device interaction**
```text
Start a device interaction session on an iOS simulator and take a screenshot.
```

**Reviewing older work**
```text
Let's run a quick review on my Parallax header demo from a previous video
```

### Terminal Commands

```bash
# §1 — Apple silicon and macOS version check
sw_vers --productVersion
uname -m

# §2 — confirm the active Xcode and that mcp-server resolves
xcodebuild -version
xcrun --find mcp-server

# §2 — pin the active developer directory to Xcode 27 if needed
sudo mv ~/Downloads/Xcode.app /Applications/Xcode-27.app
sudo xcode-select -s /Applications/Xcode-27.app/Contents/Developer

# §3 — see exactly how Xcode launches Claude, without launching it
xcrun mcpbridge run-agent --dry-run claude

# §3 — per-build agent installs, if the binary goes missing after an upgrade
ls ~/Library/Developer/Xcode/CodingAssistant/Agents/XcodeVersions

# §6 — create the ClaudeAgentConfig settings.json that denies device interaction
cd ~/Library/Developer/Xcode/CodingAssistant/ClaudeAgentConfig
touch settings.json
xed settings.json
```

---

## 🤔 What this is

AgentLoopDemo is a small SwiftUI tip-splitter used to demonstrate Xcode 27's built-in Claude Agent end to end: plan mode produces a reviewable Markdown plan, the agent writes `TipSplit.swift` and `ContentView.swift` against it, and the agent then drives the iPhone 17 Pro simulator itself — installing, tapping, and screenshotting the result. This repo also ships the `settings.json` used to lock the agent out of device-interaction tools once you're done verifying.

## ✅ Why you'd use it

- **Plan-first workflow** — see `/plan` produce a reviewable Markdown artifact before a single file changes, plus how to annotate a plan line before approving it.
- **Agent-verified UI** — a real example of Claude driving the simulator through the `DeviceInteraction*` tools and screenshotting its own result, instead of you being the one who has to look.
- **Locked-down permissions** — a ready-to-copy `settings.json` that denies the five `mcp__xcode-tools__DeviceInteraction*` tools, so device control is something you turn on and off on purpose.

## 📺 Watch on YouTube

[![Watch on YouTube](https://img.shields.io/badge/YouTube-Watch%20the%20Tutorial-red?style=for-the-badge&logo=youtube)](https://youtu.be/eLod6lBPMWk)

<!-- No existing README/video link was found for this repo — swap in the real video URL once it's live. -->

> This project was built for the [NoahDoesCoding YouTube channel](https://www.youtube.com/@NoahDoesCoding).

---

## 🚀 Getting Started

### 1. Clone
```bash
git clone https://github.com/NDCSwift/Claude_Xcode27Demo.git
cd Claude_Xcode27Demo
```

### 2. Open
```bash
open Claude_Xcode27.xcodeproj
```

### 3. Team
In Signing & Capabilities, set your own Team so Xcode can provision the app for the iPhone 17 Pro simulator.

### 4. Bundle ID
Update the bundle identifier if you plan to add the App Group entitlement from the "crank it up" prompt above, since it's derived from `<bundle-id>`.

## 🛠️ Notes

- The project `CLAUDE.md` pins the run destination to iPhone 17 Pro and iOS-only code paths — the demo template is multiplatform, and the tip-splitter code fails to build for macOS on `.keyboardType`.
- `settings.json` at the root of this repo mirrors the file described in the video. Copy it to `~/Library/Developer/Xcode/CodingAssistant/ClaudeAgentConfig/settings.json` to deny the agent's five device-interaction tools (start session, start workspace session, install & run, synthesize taps, end session). A deny rule always wins over an approval, including ones Xcode adds itself — the rules only take effect in a new conversation.
- To turn device interaction back on, delete `settings.json` (or just its `deny` entries) and start a new conversation.
- The Settings ▸ Intelligence ▸ "Allow External Agents to Use Xcode Tools" toggle only covers external agents like Claude Code running in Terminal — it does not affect Xcode's built-in agent, which is why the `settings.json` deny list is the actual control for this project.

## 📦 Requirements

- macOS Tahoe 26.6.2 or later, on Apple silicon (arm64)
- Xcode 27.0 (27A266a) or later
- iOS 27.0 SDK and the iPhone 17 Pro simulator
- Swift 6.4
- A paid Claude account (Pro or Max), or an Enterprise API key, for Claude Agent

📺 [Watch the guide on YouTube](https://youtu.be/eLod6lBPMWk)
