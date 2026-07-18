#!/usr/bin/env bash
# ONE-COMMAND PROFILE LAUNCH (username-agnostic)
# 1) Rename your username on GitHub first (Settings → Account → FakharEAli)
# 2) Then run from this folder:  bash launch.sh
set -euo pipefail
cd "$(dirname "$0")"

LOGIN=$(gh api user --jq .login)
echo "▸ Detected GitHub username: $LOGIN"

echo "▸ 1/5 Fixing git identity (so every future commit counts on your graph)…"
git config --global user.name "Fakhar E Ali"
git config --global user.email "92650421+${LOGIN}@users.noreply.github.com"

echo "▸ 2/5 Stamping username into README…"
sed -i '' "s/alifakhar816/${LOGIN}/g" README.md

echo "▸ 3/5 Creating public repo ${LOGIN}/${LOGIN} and pushing profile…"
if [ ! -d .git ]; then git init -b main -q; fi
git add README.md assets .github
git commit -q -m "feat: launch profile — animated header, production systems, self-updating sections" || true
gh repo create "${LOGIN}/${LOGIN}" --public \
  --description "⚡ My GitHub profile — AI systems that run real businesses" \
  --source . --push

echo "▸ 4/5 Triggering the snake + activity workflows…"
sleep 5
gh workflow run snake.yml    -R "${LOGIN}/${LOGIN}" || echo "  (run it later from the Actions tab)"
gh workflow run activity.yml -R "${LOGIN}/${LOGIN}" || true

echo "▸ 5/5 Polishing public repo metadata…"
gh repo edit "${LOGIN}/verticalvoice-ai" \
  --remove-topic final-year-project \
  --add-topic ultravox --add-topic ai-agents --add-topic voice-ai || true
gh repo edit "${LOGIN}/viral-script-generator" \
  --description "🎬 AI viral-script generator — hooks, structure, and platform-native pacing" \
  --add-topic ai --add-topic content-creation --add-topic scriptwriting || true

echo ""
echo "✅ Done. Open https://github.com/${LOGIN} 🎉"
echo ""
echo "MANUAL (2 minutes, GitHub won't allow these via API):"
echo "  • Settings → Public profile → check 'Include private contributions on my profile'"
echo "  • Profile page → 'Customize your pins' → pin verticalvoice-ai + viral-script-generator"
echo "  • Set a status emoji (⚡) and add a LinkedIn/X link if you have one"
echo ""
echo "If you renamed your username: update local/VPS remotes when convenient —"
echo "  git remote set-url origin <new-url>   (old URLs redirect, so no rush)"
