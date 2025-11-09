# Growth Kit Submission Guide

## Files Ready for Submission ✅

All files are prepared in `/home/user/aitmpl/` on branch `feature/growth-kit-plugin`

### Files to Submit:

```
GROWTH_KIT_PR.md  (PR description)
cli-tool/components/commands/marketing/publisher-all.md
cli-tool/components/commands/marketing/publisher-devto.md
cli-tool/components/commands/marketing/publisher-linkedin.md
cli-tool/components/commands/marketing/publisher-medium.md
cli-tool/components/commands/marketing/publisher-x.md
cli-tool/components/commands/setup/vercel-analytics.md
```

## Submission Methods

### Method 1: Apply Patch File (Fastest)

1. **Fork the repository**: https://github.com/davila7/claude-code-templates

2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/claude-code-templates.git
   cd claude-code-templates
   git checkout -b feature/growth-kit-plugin
   ```

3. **Apply the patch**:
   ```bash
   # Copy growth-kit-plugin.patch from the current directory
   git apply growth-kit-plugin.patch
   ```

4. **Push and create PR**:
   ```bash
   git push -u origin feature/growth-kit-plugin
   # Then create PR on GitHub
   ```

### Method 2: Copy Files Directly

1. **Fork and clone** (same as above)

2. **Create directories**:
   ```bash
   mkdir -p cli-tool/components/commands/marketing
   ```

3. **Copy files** from `/home/user/aitmpl/` to your fork

4. **Commit and push**:
   ```bash
   git add .
   git commit -m "feat: Add Growth Kit - Content marketing automation plugin"
   git push -u origin feature/growth-kit-plugin
   ```

### Method 3: Provide GitHub Token

If you provide a GitHub Personal Access Token, I can push directly:

1. Create token: https://github.com/settings/tokens
2. Scope needed: `public_repo`
3. Share the token with me

## PR Details

**Title**: `feat: Add Growth Kit - Content marketing automation commands`

**Body**: Use the content from `GROWTH_KIT_PR.md`

**Labels to request**: `enhancement`, `documentation`, `commands`

## What Gets Added

- ✅ 6 new commands (5 marketing + 1 analytics)
- ✅ New "marketing" category
- ✅ Zero dependencies
- ✅ Multi-language support (EN/JA)
- ✅ Production-tested

## Repository Links

- Target: https://github.com/davila7/claude-code-templates
- Source: https://github.com/kanaerulabs/growth-kit
- Your fork: https://github.com/YOUR_USERNAME/claude-code-templates

## After PR Creation

The repository maintainers will:
1. Review the commands
2. Run their component generation script
3. Add to the marketplace
4. Merge if approved

Your commands will then be available via:
```bash
npx claude-code-templates@latest
```
