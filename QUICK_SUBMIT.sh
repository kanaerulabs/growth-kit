#!/bin/bash
# Quick PR submission for Growth Kit to aitmpl marketplace
# Run this on your local machine with GitHub access

set -e

echo "🚀 Growth Kit → aitmpl Marketplace PR Submission"
echo "================================================"
echo ""

# Clone your fork
echo "📥 Cloning your fork..."
cd /tmp
rm -rf claude-code-templates
git clone https://github.com/kanaerulabs/claude-code-templates.git
cd claude-code-templates

# Apply the patch
echo "🔧 Applying Growth Kit changes..."
curl -L https://raw.githubusercontent.com/kanaerulabs/growth-kit/claude/marketplace-aitmpl-hosting-011CUKZAeDdAFHDmyikuRVAd/0001-feat-Add-Growth-Kit-marketplace-plugins-for-content-.patch -o growth-kit.patch
git am growth-kit.patch

# Push to your fork
echo "⬆️  Pushing branch to your fork..."
git push origin add-growth-kit-marketplace

echo ""
echo "✅ Branch pushed successfully!"
echo ""
echo "📬 Now create the PR:"
echo "Go to: https://github.com/kanaerulabs/claude-code-templates"
echo "Click the yellow 'Compare & pull request' button"
echo ""
echo "PR Details:"
echo "  From: kanaerulabs/claude-code-templates:add-growth-kit-marketplace"
echo "  To:   davila7/claude-code-templates:main"
echo ""
echo "Title: feat: Add Growth Kit marketplace plugins for content marketing automation"
echo ""
echo "Use the description from PR_SUBMISSION_GUIDE.md"
echo ""
echo "🎉 Done!"
