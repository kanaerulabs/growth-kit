#!/bin/bash
# Growth Kit - Submit PR to aitmpl marketplace
# Run this script to submit Growth Kit to claude-code-templates

set -e

echo "🚀 Growth Kit - aitmpl Marketplace Submission"
echo "=============================================="
echo ""

# Check if patch file exists
if [ ! -f "0001-feat-Add-Growth-Kit-marketplace-plugins-for-content-.patch" ]; then
    echo "❌ Error: Patch file not found!"
    echo "Please run this script from the growth-kit directory."
    exit 1
fi

# Step 1: Fork on GitHub
echo "📋 Step 1: Fork the repository"
echo "Go to: https://github.com/davila7/claude-code-templates"
echo "Click the 'Fork' button in the top right"
echo ""
read -p "Press ENTER after you've forked the repository..."

# Step 2: Get username
echo ""
echo "📝 Step 2: Enter your GitHub username"
read -p "GitHub username: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ Error: Username cannot be empty"
    exit 1
fi

# Step 3: Clone fork
echo ""
echo "📥 Step 3: Cloning your fork..."
cd /tmp
rm -rf claude-code-templates-fork
git clone "https://github.com/$GITHUB_USERNAME/claude-code-templates.git" claude-code-templates-fork
cd claude-code-templates-fork

# Step 4: Apply patch
echo ""
echo "🔧 Step 4: Applying Growth Kit changes..."
git am ~/growth-kit/0001-feat-Add-Growth-Kit-marketplace-plugins-for-content-.patch

# Step 5: Push
echo ""
echo "⬆️  Step 5: Pushing to your fork..."
git push origin add-growth-kit-marketplace

# Step 6: Create PR
echo ""
echo "✅ Success! Branch pushed to your fork."
echo ""
echo "📬 Final Step: Create Pull Request"
echo "Go to: https://github.com/$GITHUB_USERNAME/claude-code-templates"
echo "You should see a yellow banner with 'Compare & pull request' button"
echo "Click it and submit your PR!"
echo ""
echo "PR will be from: $GITHUB_USERNAME/claude-code-templates:add-growth-kit-marketplace"
echo "PR will be to:   davila7/claude-code-templates:main"
echo ""
echo "Use the PR template from PR_SUBMISSION_GUIDE.md for your description."
echo ""
echo "🎉 Done!"
