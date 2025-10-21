# Growth Kit - Pull Request Submission Guide for aitmpl

## Overview

I've prepared a complete pull request to add Growth Kit to the claude-code-templates marketplace (aitmpl.com). This will make your Growth Kit plugins available to all Claude Code users through the aitmpl marketplace.

## What Was Added

### 1. Two New Marketplace Plugins

**growth-kit-publisher** - Content distribution toolkit
- `/x` - Generate X/Twitter threads
- `/linkedin` - Create LinkedIn posts with media support
- `/medium` - Convert to Medium articles
- `/devto` - Generate Dev.to RSS feeds
- `/all` - Publish to all platforms at once

**growth-kit-analytics** - Web analytics toolkit
- `/vercel` - Set up Vercel Analytics

### 2. New Command Categories

Created two new command categories:
- `cli-tool/components/commands/marketing/` - Social media and content distribution commands
- `cli-tool/components/commands/analytics/` - Analytics and tracking commands

### 3. Files Added

```
.claude-plugin/marketplace.json                    (+42 lines)
cli-tool/components/commands/analytics/vercel.md   (+30 lines)
cli-tool/components/commands/marketing/all.md      (+117 lines)
cli-tool/components/commands/marketing/devto.md    (+261 lines)
cli-tool/components/commands/marketing/linkedin.md (+555 lines)
cli-tool/components/commands/marketing/medium.md   (+367 lines)
cli-tool/components/commands/marketing/x.md        (+348 lines)
---
Total: 7 files changed, 1,720 insertions(+)
```

## How to Submit the Pull Request

You have two options:

### Option 1: Use the Patch File (Easiest)

I've created a patch file that contains all the changes. You can apply it to your own fork:

```bash
# 1. Fork the repository on GitHub
#    Go to: https://github.com/davila7/claude-code-templates
#    Click "Fork" button

# 2. Clone YOUR fork
git clone https://github.com/YOUR_USERNAME/claude-code-templates.git
cd claude-code-templates

# 3. Apply the patch file
git am /home/user/growth-kit/0001-feat-Add-Growth-Kit-marketplace-plugins-for-content-.patch

# 4. Push to your fork
git push origin add-growth-kit-marketplace

# 5. Create Pull Request on GitHub
#    Go to: https://github.com/YOUR_USERNAME/claude-code-templates
#    Click "Contribute" → "Open pull request"
#    Set base repository to: davila7/claude-code-templates
#    Set head repository to: YOUR_USERNAME/claude-code-templates
#    Set branch to: add-growth-kit-marketplace
#    Click "Create pull request"
```

### Option 2: Manual Setup

If you prefer to do it manually:

```bash
# 1. Fork and clone (same as above)
git clone https://github.com/YOUR_USERNAME/claude-code-templates.git
cd claude-code-templates

# 2. Create feature branch
git checkout -b add-growth-kit-marketplace

# 3. Copy files from the prepared repository
#    The complete changes are in: /tmp/claude-code-templates

# 4. Commit and push
git add .
git commit -m "feat: Add Growth Kit marketplace plugins for content marketing automation"
git push origin add-growth-kit-marketplace

# 5. Create PR on GitHub (same as above)
```

## Pull Request Details

### Title
```
feat: Add Growth Kit marketplace plugins for content marketing automation
```

### Description

Use this template for your PR description:

```markdown
## Overview

Adding Growth Kit from Kanaeru Labs to the Claude Code Templates marketplace. Growth Kit provides content marketing automation tools for blog post distribution across social media platforms.

## Plugins Added

### 1. growth-kit-publisher
Content distribution toolkit for automating social media posts from blog content.

**Commands:**
- `/x` - Generate X/Twitter threads from blog posts
- `/linkedin` - Create LinkedIn posts with automatic media upload
- `/medium` - Convert blog posts to Medium-ready articles
- `/devto` - Generate Dev.to RSS feed for auto-import
- `/all` - Generate content for all platforms at once

**Features:**
- Accepts any input format (markdown, PDF, URL, plain text)
- Works in any repository type (no dependencies)
- Supports multiple languages (English, Japanese)
- Auto-detects blog structure

### 2. growth-kit-analytics
Web analytics setup automation.

**Commands:**
- `/vercel` - Automated Vercel Analytics setup

## New Categories

Created two new command categories:
- `marketing/` - Social media and content distribution
- `analytics/` - Analytics and tracking (in commands)

## Source

- **Repository:** https://github.com/kanaerulabs/growth-kit
- **Version:** 1.0.0
- **License:** MIT
- **Author:** Kanaeru Labs (support@kanaeru.ai)
- **Website:** https://www.kanaeru.ai

## Testing

All commands have been tested with real blog posts and work across different repository types (Python, JavaScript, Rust, Go, etc.).

## Files Changed

- `.claude-plugin/marketplace.json` - Added two new plugins
- `cli-tool/components/commands/marketing/` - 5 new marketing commands
- `cli-tool/components/commands/analytics/` - 1 new analytics command

Total: 7 files changed, 1,720 insertions(+)
```

## What Happens After Submission

1. The maintainer (Daniel Avila) will review your pull request
2. They may request changes or ask questions
3. Once approved, your plugins will be merged into the main branch
4. Users can then install Growth Kit via:
   ```bash
   npx claude-code-templates --plugin growth-kit-publisher
   npx claude-code-templates --plugin growth-kit-analytics
   ```

## Benefits of Being in the aitmpl Marketplace

1. **Discoverability** - Listed on aitmpl.com alongside 400+ other components
2. **Easy Installation** - Users can install via the CLI tool
3. **Community** - Join the Claude Code Templates ecosystem
4. **Documentation** - Your plugins appear in the docs at docs.aitmpl.com
5. **Validation** - Official listing gives credibility to your marketplace

## Files Reference

- **Patch File:** `/home/user/growth-kit/0001-feat-Add-Growth-Kit-marketplace-plugins-for-content-.patch`
- **Prepared Repository:** `/tmp/claude-code-templates` (on the `add-growth-kit-marketplace` branch)

## Need Help?

- **Repository Issues:** https://github.com/davila7/claude-code-templates/issues
- **Repository Discussions:** https://github.com/davila7/claude-code-templates/discussions
- **Contributing Guide:** https://github.com/davila7/claude-code-templates/blob/main/CONTRIBUTING.md

---

**Ready to submit!** Follow Option 1 above to apply the patch and create your PR in just 5 commands.
