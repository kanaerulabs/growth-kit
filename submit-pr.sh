#!/bin/bash

# Growth Kit PR Submission Script
# This script helps submit the Growth Kit plugin to aitmpl repository

set -e

echo "🚀 Growth Kit PR Submission Helper"
echo "=================================="
echo ""

# Check if GitHub token is provided
if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Error: GITHUB_TOKEN environment variable not set"
    echo ""
    echo "To use this script:"
    echo "1. Create a GitHub Personal Access Token:"
    echo "   https://github.com/settings/tokens"
    echo "   (Scope: public_repo)"
    echo ""
    echo "2. Run this script with your token:"
    echo "   GITHUB_TOKEN=your_token_here ./submit-pr.sh YOUR_GITHUB_USERNAME"
    echo ""
    echo "Or apply the patch manually (see SUBMISSION_GUIDE.md)"
    exit 1
fi

if [ -z "$1" ]; then
    echo "❌ Error: GitHub username required"
    echo ""
    echo "Usage: GITHUB_TOKEN=your_token ./submit-pr.sh YOUR_GITHUB_USERNAME"
    exit 1
fi

GITHUB_USERNAME="$1"
REPO_PATH="/home/user/aitmpl"

echo "📋 Configuration:"
echo "   GitHub User: $GITHUB_USERNAME"
echo "   Target Repo: davila7/claude-code-templates"
echo "   Branch: feature/growth-kit-plugin"
echo ""

# Check if fork exists (optional check)
echo "🔍 Checking if fork exists..."
FORK_CHECK=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/repos/$GITHUB_USERNAME/claude-code-templates" | grep -o '"name"' || echo "")

if [ -z "$FORK_CHECK" ]; then
    echo "⚠️  Fork not found. Creating fork..."
    curl -X POST -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/davila7/claude-code-templates/forks"
    echo "✅ Fork created!"
    echo "⏳ Waiting 5 seconds for fork to be ready..."
    sleep 5
else
    echo "✅ Fork already exists"
fi

# Update remote URL with token
cd "$REPO_PATH"
echo ""
echo "🔗 Configuring remote..."
git remote set-url origin "https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/claude-code-templates.git"

# Push the branch
echo ""
echo "📤 Pushing branch..."
git push -u origin feature/growth-kit-plugin

echo ""
echo "✅ Branch pushed successfully!"
echo ""
echo "📝 Next steps:"
echo "1. Go to: https://github.com/$GITHUB_USERNAME/claude-code-templates"
echo "2. Click 'Compare & pull request' button"
echo "3. Copy PR description from GROWTH_KIT_PR.md"
echo "4. Submit the pull request!"
echo ""
echo "🎉 You're almost done!"
